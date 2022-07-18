import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Components/Tab_Views/chart_view.dart';
import '../Components/Tab_Views/home_view.dart';
import '../Models/food_model.dart';
import '../Pages/welcome_screen.dart';
import '../constants.dart';

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
      rethrow;
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
    meals = [];
    limits = {};
    await FirebaseFirestore.instance
        .collection("Standard_food_size")
        .get()
        .then((value1) async {
      for (DocumentSnapshot<Map?> doc in value1.docs) {
        meals.add(doc.id);
        limits[doc.id] = [doc.data()!['limit'][0], doc.data()!['limit'][1]];
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
    }).catchError((e) {
      print(e);
    });
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
    }).catchError((e) {
      print(e);
    });
    return meals;
  }

  static fetchStats() async {
    todayStat = {};
    weekStat = [];
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      weekStat.add({
        'date': today.subtract(Duration(days: i)).toString().substring(0, 10)
      });
    }
    for (String meal in meals) {
      todayStat[meal] = 0;
      for (int i = 0; i < 7; i++) {
        weekStat[i][meal] = 0;
      }
    }

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection('foodLog')
        .doc(DateTime.now().toString().substring(0, 10))
        .get()
        .then((value) {
      Map data = value.data() != null ? value.data() as Map : {};
      data.forEach((key, value) {
        for (Map food in value) {
          print(food['amount'].runtimeType);
          int amount = food['unit'] == null || food['unit'] != 'table spoon'
              ? food['amount'].toInt()
              : (food['amount'] / 3).toInt();
          print(amount);
          print(food['type']);
          print(todayStat);

          todayStat[food['type']] = todayStat[food['type']] + amount;
          print(todayStat[food['type']]);
        }
      });
    }).catchError((e) {
      print(e);
    });

    for (int i = 0; i < 7; i++) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection('foodLog')
          .doc(weekStat[i]['date'])
          .get()
          .then((value) {
        Map data = value.data() != null ? value.data() as Map : {};
        data.forEach((key, value) {
          for (Map food in value) {
            int amount = food['unit'] == null || food['unit'] != 'table spoon'
                ? food['amount'].toInt()
                : (food['amount'] / 3).toInt();

            weekStat[i][food['type']] = weekStat[i][food['type']] + amount;
          }
        });
      }).catchError((e) {});
      int count = 0;
      weekStat[i].forEach((key, value) {
        if (key != 'date' && value > 0) {
          count++;
        }
      });
      weekStat[i]['count'] = count;
    }
    return true;
  }
}
