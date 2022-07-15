import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';
import 'package:mobile_app/Pages/add_new_food_screen.dart';

final _firestore = FirebaseFirestore.instance;

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
    dateMeals[selectedMealTime].remove(meal);
    // getFoodData1();
    // for (Map meal1 in mealList) {
    //   if (meal1['name'] == meal["name"]) {
    //     int index = mealList.indexOf(meal1);
    //     mealList.removeAt(index);
    //     break;
    //   }
    // }
  }

  void getFoodData1() async {
    final foodItems = await _firestore
        .collection('foodLog')
        .doc(selectedDate.toString())
        .collection(selectedMealTime.toString())
        .get();
    for (var food in foodItems.docs) {
      if (food.data()['food'] == meal["name"]) {
        await _firestore
            .collection('foodLog')
            .doc(selectedDate.toString())
            .collection(selectedMealTime.toString())
            .doc(food.reference.id)
            .delete();
      }
    }
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
                Text(
                  meal["food"],
                  style: const TextStyle(fontSize: 18),
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
