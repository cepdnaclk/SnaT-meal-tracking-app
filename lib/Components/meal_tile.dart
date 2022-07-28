import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Models/food_model.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';
import 'package:mobile_app/Pages/add_new_food_screen.dart';

import '../Pages/welcome_screen.dart';

final _firestore = FirebaseFirestore.instance;

class MealTile extends StatelessWidget {
  const MealTile({
    Key? key,
    required this.meal,
    required this.reloadState,
    required this.index,
  }) : super(key: key);

  final Map meal;
  final void Function() reloadState;
  final int index;

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
        var foodList = data[selectedMealTime.toString()];
        if (foodList != null) {
          for (var food in foodList) {
            if (food['food'] == meal['food']) {
              int index = foodList.indexOf(food);
              foodList.removeAt(index);
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
                    editedMeal = meal;
                    editedIndex = index;
                    FoodModel food = FoodModel(
                        name: meal['food'],
                        unit: meal['unit'],
                        mealType: meal['type'],
                        iconCode: meal["iconCode"]);

                    result = food;
                    resultText = meal["food"];
                    amount1 = meal["amount"].toString();
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
                  (meal["amount"].toInt().toDouble() == meal["amount"]
                              ? meal["amount"].toInt()
                              : meal["amount"])
                          .toString() +
                      ' ' +
                      meal['unit'],
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
