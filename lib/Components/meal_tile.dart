import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';
import 'package:mobile_app/Pages/add_new_food_screen.dart';

class MealTile extends StatelessWidget {
  const MealTile({Key? key, required this.meal, required this.ReloadState})
      : super(key: key);

  final Map meal;
  final void Function() ReloadState;

  void deleteTile() {
    for (Map meal1 in mealItems) {
      if (meal1['name'] == meal["name"]) {
        int index = mealItems.indexOf(meal1);
        mealItems.removeAt(index);
        break;
      }
    }
  }

  void editTile() {
    for (Map meal1 in mealItems) {
      if (meal1['name'] == meal["name"]) {
        int index = mealItems.indexOf(meal1);
        mealItems[index]['name'] = "Food Selected";
        mealItems[index]['icon'] = Icons.food_bank;
        break;
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
        child: Row(
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
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => AddNewFoodScreen(
                          AppBarTitle: Text("Add Quantity"),
                        ));
                editTile();
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
      ),
    );
  }
}
