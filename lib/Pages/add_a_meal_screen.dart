import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/add_new_food_screen.dart';
import 'package:mobile_app/Pages/welcome_screen.dart';
import 'package:mobile_app/Services/DateTime.dart';

import '../Components/Tab_Views/home_view.dart';
import '../Components/date_time_widget.dart';
import '../Components/meal_tile.dart';
import '../Models/food_model.dart';
import '../Theme/theme_info.dart';
import '../constants.dart';

String resultText = "";
String unit = "";
double amount = 0.0;
String iconCode = "";
FoodModel? result;

String? selectedMeal;
String? selectedMealTime;
DateTime selectedDate = DateTime.now();
List foodArray = [];
Map dateMeals = {};

class AddAMealScreen extends StatefulWidget {
  const AddAMealScreen({Key? key, required this.onChanged}) : super(key: key);
  final Function onChanged;

  @override
  State<AddAMealScreen> createState() => _AddAMealScreenState();
}

class _AddAMealScreenState extends State<AddAMealScreen> {
  final _mealFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    selectedMeal = selectedMeal;
    selectedMealTime = selectedMealTime;
    dateMeals = todayMeals;
  }

  void stateReload() {
    print("State reload");
    setState(() {});
  }

  getDateMeals() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("foodLog")
        .doc(selectedDate.toString().substring(0, 10))
        .get()
        .then((value) {
      dateMeals = value.data() ?? {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _mealFormKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add new meal"),
          backgroundColor: ThemeInfo.primaryColor,
          actions: [
            GestureDetector(
              onTap: () async {
                /* dateMeals[selectedMealTime] != null
                    ? dateMeals[selectedMealTime].add({
                        'amount': amount.round(),
                        'food': resultText,
                        'unit': unit,
                        'mealtype': selectedMeal,
                      })
                    : dateMeals[selectedMealTime] = [
                        {
                          'amount': amount.round(),
                          'food': resultText,
                          'unit': unit,
                          'mealtype': selectedMeal,
                        }
                      ];*/
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .collection("foodLog")
                    .doc(selectedDate.toString().substring(0, 10))
                    .update({
                  selectedMealTime!: dateMeals[selectedMealTime]
                }).catchError((e) async {
                  print(e.toString());
                  if (e.toString() ==
                      "[cloud_firestore/not-found] Some requested document was not found.") {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(user!.uid)
                        .collection("foodLog")
                        .doc(selectedDate.toString().substring(0, 10))
                        .set({selectedMealTime!: dateMeals[selectedMealTime]});
                    print('done');
                  }
                });
                widget.onChanged();
                Navigator.pop(context);
              },
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
                    await getDateMeals();
                    setState(() {});
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                "Meal Time",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            DropdownButtonFormField(
              validator: (val) {
                if (val == null) {
                  return "Please select a meal time before adding food";
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: mealTime.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? val) {
                selectedMealTime = val;
                result = null;
                amount = 1;
                setState(() {});
              },
              hint: const Text('Please select a meal time'),
            ),
            const SizedBox(
              height: 5,
            ),
            const Center(
              child: Text(
                "Meal Type",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            DropdownButtonFormField(
              validator: (String? val) {
                if (val == null) {
                  return "Please select a meal type before adding food";
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: meals.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? val) {
                selectedMeal = val;
                result = null;
                amount = 1;
              },
              hint: const Text('Please select a meal type'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_mealFormKey.currentState!.validate()) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => AddNewFoodScreen(
                      appBarTitle: const Text(
                        "Add a New Food",
                      ),
                      reloadState: stateReload,
                      tileEdit: false,
                    ),
                  );
                }
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
            for (Map meal in dateMeals[selectedMealTime] ?? [])
              MealTile(
                meal: meal,
                reloadState: stateReload,
              )
          ],
        ),
      ),
    );
  }
}
