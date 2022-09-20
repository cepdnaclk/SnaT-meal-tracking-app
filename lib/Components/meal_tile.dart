import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';

import '../Models/food_model.dart';
import '../Pages/add_new_food_screen.dart';

enum Menu { itemOne, itemTwo }

class MealTile extends StatelessWidget {
  const MealTile({
    Key? key,
    required this.meal,
    required this.reloadState,
    required this.index,
    required this.context2,
  }) : super(key: key);

  final Map meal;
  final void Function() reloadState;
  final int index;
  final BuildContext context2;

  void deleteTile() {
    dateMeals[selectedMealTime].remove(meal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 7,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: Colors.grey[300]!),
        ),
      ),
      child: SizedBox(
        height: 75,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset("assets/images/${meal['type']}.png")),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    meal["food"],
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    (meal["amount"] == 0.25
                                ? "1/4"
                                : meal["amount"] == 0.5
                                    ? "1/2"
                                    : meal["amount"].toInt().toDouble() ==
                                            meal["amount"]
                                        ? meal["amount"].toInt()
                                        : meal["amount"])
                            .toString() +
                        ' ' +
                        meal['unit'].replaceRange(
                            0, 1, meal['unit'].substring(0, 1).toUpperCase()),
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  Text(
                    meal["type"],
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return <PopupMenuEntry<Menu>>[
                  const PopupMenuItem<Menu>(
                    value: Menu.itemOne,
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: Menu.itemTwo,
                    child: Text('Delete'),
                  ),
                ];
              },
              onSelected: (Menu val) {
                switch (val) {
                  case Menu.itemOne:
                    editedIndex = index;
                    FoodModel food = FoodModel(
                        name: meal['food'],
                        unit: meal['unit'],
                        mealType: meal['type'],
                        iconCode: meal["iconCode"]);
                    result = food;
                    amount1 = meal["amount"].toString();
                    showModalBottomSheet(
                      context: context2,
                      builder: (context2) => AddNewFoodScreen(
                        reloadState: reloadState,
                        appBarTitle: const Text("Add Quantity"),
                        tileEdit: true,
                      ),
                    );
                    break;
                  case Menu.itemTwo:
                    deleteTile();
                    reloadState();
                    break;
                }
              },
              position: PopupMenuPosition.under,
            ),
          ],
        ),
      ),
    );
  }
}
