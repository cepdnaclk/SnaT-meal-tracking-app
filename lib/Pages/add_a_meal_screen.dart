import 'package:flutter/material.dart';
import 'package:mobile_app/Services/DateTime.dart';

import '../Components/date_time_widget.dart';
import '../Components/meal_tile.dart';

class AddAMealScreen extends StatefulWidget {
  const AddAMealScreen({Key? key}) : super(key: key);

  @override
  State<AddAMealScreen> createState() => _AddAMealScreenState();
}

class _AddAMealScreenState extends State<AddAMealScreen> {
  DateTime selectedDate = DateTime.now();

  String? selectedMeal;

  List<String> meals = ["Rice & Curry", "Bread", "Noodles"];
  List mealItems = [
    {"name": "Rice & Curry", "icon": Icons.fastfood},
    {"name": "Bread", "icon": Icons.fastfood},
    {"name": "Tea", "icon": Icons.local_cafe}
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
              setState(() {});
            },
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
            onPressed: () {},
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
          for (Map meal in mealItems) MealTile(meal: meal)
        ],
      ),
    );
  }
}
