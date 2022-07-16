import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';
import 'package:mobile_app/Pages/add_new_food_screen.dart';

final _firestore = FirebaseFirestore.instance;
User? user = FirebaseAuth.instance.currentUser;

class MealTile extends StatelessWidget {
  const MealTile({
    Key? key,
    required this.meal,
    required this.reloadState,
    //required this.foodAmount,
  }) : super(key: key);

  final Map meal;
  //final String foodAmount;
  final void Function() reloadState;

  // void editTile(String name, String amount) {
  //   for (Map meal1 in mealList) {
  //     if (meal1['name'] == meal["name"]) {
  //       int index = mealList.indexOf(meal1);
  //       mealList[index]['name'] = name;
  //       mealList[index]['icon'] = Icons.food_bank;
  //       mealList[index]['amount'] = amount;
  //       break;
  //     }
  //   }
  // }

  void deleteTile() {
    getFoodData1();
    dateMeals[selectedMealTime].remove(meal);
  }

  void getFoodData1() async {
    await _firestore
        .collection("users")
        .doc(user!.uid)
        .collection('foodLog')
        .doc(selectedDate.toString().substring(0, 10))
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;
        var foodlist = data[selectedMealTime.toString()];
        if (foodlist != null) {
          for (var food in foodlist) {
            if (food['food'] == meal['food']) {
              int index = foodlist.indexOf(food);
              foodlist.removeAt(index);
              break;
            }
          }
        }
        _firestore
            .collection("users")
            .doc(user!.uid)
            .collection('foodLog')
            .doc(selectedDate.toString().substring(0, 10))
            .update(data)
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      } else {
        print('Document does not exist on the database');
      }
    });
    // for (var food in foodItems.docs) {
    //   print(food);
    //   if (food.data()['food'] == meal["name"]) {
    //     await _firestore
    //         .collection("users")
    //         .doc(user!.uid)
    //         .collection('foodLog')
    //         .doc(selectedDate.toString())
    //         .collection(selectedMealTime.toString())
    //         .doc(food.reference.id)
    //         .delete();
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.black,
      )),
      child: MaterialButton(
        onPressed: () {},
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  IconData(int.parse('0x' + meal["iconCode"]),
                      fontFamily: "MaterialIcons"),
                  size: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    meal["food"],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => AddNewFoodScreen(
                              appBarTitle: const Text("Add Quantity"),
                              reloadState: reloadState,
                              tileEdit: true,
                              //editTileDetails: editTile,
                            ));
                    // editTile();
                    reloadState();
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    deleteTile();
                    reloadState();
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 30,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  meal["amount"].toString() + ' ' + meal['unit'],
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  meal["type"],
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
