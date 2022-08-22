import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/welcome_screen.dart';
import 'package:mobile_app/Services/DateTime.dart';

import '../Components/date_time_widget.dart';
import '../Components/meal_tile.dart';
import '../Models/food_model.dart';
import '../Theme/theme_info.dart';
import '../constants.dart';
import 'add_new_food_screen.dart';

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
  bool hasTimeError = false;
  bool hasMealError = false;

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(addNewMealTitle),
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
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(saveButton),
              )),
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dateAndTime,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 5,
                ),
                DateTimeWidget(
                  iconPic: Icon(datePickerIcon),
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
            Text(
              mealTime,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
              child: DropdownButtonFormField(
                value: selectedMealTime,
                style: TextStyle(
                    color: ThemeInfo.dropDownValueColor, fontSize: 18),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: mealTimes.map((String value) {
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
                hint: Text(mealTimeDropdownHint),
              ),
            ),
            if (hasTimeError)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  mealTimeDropdownErrorMessage,
                  style:
                      TextStyle(color: ThemeInfo.errorTextColor, fontSize: 12),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Text(
              mealType,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
              child: DropdownButtonFormField(
                value: selectedMeal,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                    color: ThemeInfo.dropDownValueColor, fontSize: 18),
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
                hint: Text(mealTypeDropdownHint),
              ),
            ),
            if (hasMealError)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  mealTypeDropdownErrorMessage,
                  style:
                      TextStyle(color: ThemeInfo.errorTextColor, fontSize: 12),
                ),
              ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () async {
                if (selectedMealTime != null && selectedMeal != null) {
                  hasTimeError = false;
                  hasMealError = false;
                  setState(() {});
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => AddNewFoodScreen(
                      appBarTitle: Text(
                        addFoodButton,
                      ),
                      reloadState: stateReload,
                      tileEdit: false,
                    ),
                  );
                } else if (selectedMeal != null && selectedMealTime == null) {
                  hasTimeError = true;
                  hasMealError = false;
                  setState(() {});
                } else if (selectedMeal == null && selectedMealTime != null) {
                  hasTimeError = false;
                  hasMealError = true;
                  setState(() {});
                } else {
                  hasTimeError = true;
                  hasMealError = true;
                  setState(() {});
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.teal,
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Center(
                  child: Text(
                    addFoodButton,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              mealItems,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            if (dateMeals[selectedMealTime] == null ||
                dateMeals[selectedMealTime].isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    noFoodMessage,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            for (int i = 0; i < (dateMeals[selectedMealTime] ?? []).length; i++)
              MealTile(
                meal: dateMeals[selectedMealTime][i],
                reloadState: stateReload,
                index: i,
                context2: context,
              )
          ],
        ),
      ),
    );
  }
}
