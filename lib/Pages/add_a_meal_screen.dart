import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/add_new_food_screen.dart';
import 'package:mobile_app/Pages/welcome_screen.dart';
import 'package:mobile_app/Services/DateTime.dart';

import '../Components/date_time_widget.dart';
import '../Components/meal_tile.dart';
import '../Models/food_model.dart';
import '../Theme/theme_info.dart';
import '../constants.dart';

FoodModel? result;
String amount1 = "1";
int? editedIndex;
String? selectedMeal;
String? selectedMealTime;
DateTime selectedDate = DateTime.now();
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
    selectedDate = DateTime.now();
    selectedMeal = selectedMeal;
    selectedMealTime = selectedMealTime;
    getDateMeals();
  }

  @override
  void dispose() {
    selectedMeal = null;
    selectedMealTime = null;
    selectedDate = DateTime.now();
    dateMeals = {};
    result = null;
    amount1 = "1";
    super.dispose();
  }

  void stateReload() {
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
    setState(() {});
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Date and time",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 5,
                ),
                DateTimeWidget(
                  iconPic: const Icon(
                    Icons.calendar_today_sharp,
                  ),
                  selectedDate: selectedDate,
                  text: DateTimeService.getDateString(selectedDate),
                  onPressed: (val) async {
                    selectedDate = val;
                    getDateMeals();
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Meal Time",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            DropdownButtonFormField(
              value: selectedMealTime,
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
                setState(() {});
              },
              hint: const Text('Please select a meal time'),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Meal Type",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            DropdownButtonFormField(
              value: selectedMeal,
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
              },
              hint: const Text('Please select a meal type'),
            ),
            const SizedBox(
              height: 30,
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
              "Meal items",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            if (dateMeals[selectedMealTime] == null ||
                dateMeals[selectedMealTime].isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    "No food items added 🙁",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            for (int i = 0; i < (dateMeals[selectedMealTime] ?? []).length; i++)
              MealTile(
                meal: dateMeals[selectedMealTime][i],
                reloadState: stateReload,
                index: i,
              )
          ],
        ),
      ),
    );
  }
}
