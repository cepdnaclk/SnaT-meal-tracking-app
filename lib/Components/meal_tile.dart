import 'package:flutter/material.dart';
import 'package:mobile_app/Models/food_model.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';
import 'package:mobile_app/Pages/add_new_food_screen.dart';

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
    dateMeals[selectedMealTime].remove(meal);
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
                    editedIndex = index;
                    FoodModel food = FoodModel(
                        name: meal['food'],
                        unit: meal['unit'],
                        mealType: meal['type'],
                        iconCode: meal["iconCode"]);
                    result = food;
                    amount1 = meal["amount"].toString();
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => AddNewFoodScreen(
                        reloadState: reloadState,
                        appBarTitle: const Text("Add Quantity"),
                        tileEdit: true,
                      ),
                    );
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
