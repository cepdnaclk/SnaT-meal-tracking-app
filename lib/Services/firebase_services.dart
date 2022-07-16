import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_app/Pages/welcome_screen.dart';

import '../Components/Tab_Views/home_view.dart';
import '../Models/food_model.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await _auth.signInWithCredential(authCredential);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  getWeekStats() async {
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
  }

  static Future<bool> getFoodsData() async {
    await FirebaseFirestore.instance
        .collection("Food Data")
        .get()
        .then((value1) async {
      for (DocumentSnapshot doc in value1.docs) {
        List<FoodModel> array = [];
        await FirebaseFirestore.instance
            .collection("Standard_food_size")
            .doc(doc.id)
            .collection("Food")
            .get()
            .then((value2) async {
          for (DocumentSnapshot doc2 in value2.docs) {
            Map data = doc2.data() as Map;
            FoodModel food = FoodModel(
                name: data['Food'],
                unit: data['Unit'],
                mealType: doc.id,
                standardSize: data['Standard_Size'],
                iconCode: data['iconCode']);
            array.add(food);
          }
        }).catchError((e) {
          print("e2$e");
        });
        foodsData[doc.id] = array;
      }
    }).catchError((e) {});
    return true;
  }

  static Future<Map> fetchData() async {
    Map meals = {};
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection('foodLog')
        .doc(DateTime.now().toString().substring(0, 10))
        .get()
        .then((value) {
      meals = {
        "Breakfast": value.data()?['Breakfast'] ?? [],
        "Morning Snacks": value.data()?['Morning Snacks'] ?? [],
        "Lunch": value.data()?['Lunch'] ?? [],
        "Evening Snacks": value.data()?['Evening Snacks'] ?? [],
        "Dinner": value.data()?['Dinner'] ?? [],
        "Others": value.data()?['Others'] ?? [],
      };
    }).catchError((e) {});
    return meals;
  }
}
