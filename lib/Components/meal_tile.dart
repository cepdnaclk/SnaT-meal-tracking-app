import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';
import 'package:mobile_app/Pages/add_new_food_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class MealTile extends StatelessWidget {
  const MealTile({
    Key? key,
    required this.meal,
    required this.ReloadState,
    required this.foodamount,
  }) : super(key: key);

  final Map meal;
  final String foodamount;
  final void Function() ReloadState;

  void editTile(String name, String amount) {
    print(meal['name']);
    print("hey");
    for (Map meal1 in mealList) {
      if (meal1['name'] == meal["name"]) {
        int index = mealList.indexOf(meal1);
        print(index);
        mealList[index]['name'] = name;
        mealList[index]['icon'] = Icons.food_bank;
        mealList[index]['amount'] = amount;
        break;
      }
    }
  }

  void deleteTile() {
    getFoodData1();
    for (Map meal1 in mealList) {
      if (meal1['name'] == meal["name"]) {
        int index = mealList.indexOf(meal1);
        mealList.removeAt(index);
        break;
      }
    }
  }

  void getFoodData1() async {
    print(selectedMealTime);
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
                  meal["icon"],
                  size: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  meal["name"],
                  style: const TextStyle(fontSize: 18),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => AddNewFoodScreen(
                              AppBarTitle: Text("Add Quantity"),
                              ReloadState: ReloadState,
                              tileEdit: true,
                              editTileDetails: editTile,
                            ));
                    // editTile();
                    ReloadState();
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    deleteTile();
                    ReloadState();
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 30,
                  ),
                ),
              ],
            ),
            Text(
              meal["amount"],
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
