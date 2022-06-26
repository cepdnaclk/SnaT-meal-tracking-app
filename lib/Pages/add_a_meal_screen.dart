import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/add_new_food_screen.dart';
import 'package:mobile_app/Services/DateTime.dart';
import 'package:mobile_app/Services/custom_page_route.dart';

import '../Components/date_time_widget.dart';
import '../Components/meal_tile.dart';

String foodamount = "";
List mealItems = [
  {"name": "Rice & Curry", "icon": Icons.rice_bowl, "amount": "2 cups"},
  {"name": "Bread", "icon": Icons.food_bank, "amount": "1 portion"},
  {"name": "Tea", "icon": Icons.emoji_food_beverage, "amount": "1 cup"}
];
void addMealItems(String name, String amount) {
  mealItems.add({"name": name, "icon": Icons.rice_bowl, "amount": amount});
  print(mealItems);
}

class AddAMealScreen extends StatefulWidget {
  const AddAMealScreen({Key? key}) : super(key: key);

  @override
  State<AddAMealScreen> createState() => _AddAMealScreenState();
}

class _AddAMealScreenState extends State<AddAMealScreen> {
  DateTime selectedDate = DateTime.now();

  String? selectedMeal;

  void StateReload() {
    print("State reload");
    setState(() {});
  }

  List<String> meals = [
    " Cereals and starchy foods",
    "Vegetables",
    "Fruits",
    "Pulses meat fish",
    "Beverages",
    "Milk and milk products"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new meal"),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text("Save"),
            )),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Date and time:",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              DateTimeWidget(
                iconPic: const Icon(
                  Icons.calendar_today,
                ),
                selectedDate: selectedDate,
                text: DateTimeService.dateConverter(selectedDate),
                onPressed: (val) async {
                  selectedDate = val;
                  print(val);
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Meal:",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 5,
          ),
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                  //labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                isEmpty: selectedMeal == '',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text('Please select a meal'),
                    value: selectedMeal,
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMeal = newValue;
                        print(selectedMeal);
                        state.didChange(newValue);
                      });
                    },
                    items: meals.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => AddNewFoodScreen(
                        AppBarTitle: Text("Add a New Food"),
                        ReloadState: StateReload,
                        tileEdit: false,
                      ));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                "Add a food",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Meal items:",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 5,
          ),
          for (Map meal in mealItems)
            MealTile(
              meal: meal,
              ReloadState: StateReload,
              foodamount: foodamount,
            )
        ],
      ),
    );
  }
}
