import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/add_new_food_screen.dart';
import 'package:mobile_app/Services/DateTime.dart';
import 'package:mobile_app/Services/custom_page_route.dart';
import '../Components/date_time_widget.dart';
import '../Components/meal_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Theme/theme_info.dart';

final _firestore = FirebaseFirestore.instance;
bool todayDate = (selectedDate.toString().substring(0, 10) ==
        DateTime.now().toString().substring(0, 10))
    ? true
    : false;

List mealList = [];
String foodamount = "";
List Today_breakFastMealItems = [
  {"name": "Rice & Curry", "icon": Icons.rice_bowl, "amount": "2 cups"},
  {"name": "Bread", "icon": Icons.food_bank, "amount": "1 portion"},
  {"name": "Tea", "icon": Icons.emoji_food_beverage, "amount": "1 cup"}
];
List Today_LunchMealItems = [];
List Today_DinnerMealItems = [];
List Today_MorningSnacksMealItems = [];
List Today_EveningSnacksMealItems = [];
List Today_OtherMealItems = [];

List NotToday_breakFastMealItems = [];
List NotToday_LunchMealItems = [];
List NotToday_DinnerMealItems = [];
List NotToday_MorningSnacksMealItems = [];
List NotToday_EveningSnacksMealItems = [];
List NotToday_OtherMealItems = [];

List<String> meals = [
  "Cereals and starchy foods",
  "Vegetables",
  "Fruits",
  "Pulses meat fish",
  "Beverages",
  "Milk and milk products"
];
List<String> mealTime = [
  "Breakfast",
  "Morning Snacks",
  "Lunch",
  "Evening Snacks",
  "Dinner",
  "Others"
];

List<Map> Today_mealTimeLists = [
  {"mealtime": "Breakfast", "List": Today_breakFastMealItems},
  {"mealtime": "Morning Snacks", "List": Today_MorningSnacksMealItems},
  {"mealtime": "Lunch", "List": Today_LunchMealItems},
  {"mealtime": "Evening Snacks", "List": Today_EveningSnacksMealItems},
  {"mealtime": "Dinner", "List": Today_DinnerMealItems},
  {"mealtime": "Others", "List": Today_OtherMealItems}
];

List<Map> NotToday_mealTimeLists = [
  {"mealtime": "Breakfast", "List": NotToday_breakFastMealItems},
  {"mealtime": "Morning Snacks", "List": NotToday_MorningSnacksMealItems},
  {"mealtime": "Lunch", "List": NotToday_LunchMealItems},
  {"mealtime": "Evening Snacks", "List": NotToday_EveningSnacksMealItems},
  {"mealtime": "Dinner", "List": NotToday_DinnerMealItems},
  {"mealtime": "Others", "List": NotToday_OtherMealItems}
];

void getFoodData(String selectedMealCategory) async {
  final foodItems = await _firestore
      .collection('Standard_food_size')
      .doc(selectedMealCategory)
      .collection('Food')
      .get();
  SearchTerms = [];
  FoodandUnits = [];
  for (var food in foodItems.docs) {
    SearchTerms.add(food.data()['Food']);
    FoodandUnits.add(
        {"Food": food.data()['Food'], "Units": food.data()['Unit']});
  }
}

void addMealItems(String name, String amount) {
  print("plz" + selectedMealTime.toString());
  for (Map meallist in mealTimeLists) {
    if (meallist["mealtime"] == selectedMealTime) {
      print(meallist['List']);
      mealList = meallist["List"];
    }
  }
  print(mealList);
  mealList.add({"name": name, "icon": Icons.rice_bowl, "amount": amount});
}

List<Map> mealTimeLists = [];
String? selectedMeal;
String? selectedMealTime;
DateTime selectedDate = DateTime.now();

class AddAMealScreen extends StatefulWidget {
  const AddAMealScreen({Key? key}) : super(key: key);

  @override
  State<AddAMealScreen> createState() => _AddAMealScreenState();
}

class _AddAMealScreenState extends State<AddAMealScreen> {
  void initState() {
    super.initState();
    bool todayDate = (selectedDate.toString().substring(0, 10) ==
            DateTime.now().toString().substring(0, 10))
        ? true
        : false;
    mealTimeLists =
        (todayDate == true) ? Today_mealTimeLists : NotToday_mealTimeLists;
    print(mealTimeLists);
    selectedMeal = selectedMeal;
    selectedMealTime = selectedMealTime;
    // print(selectedMeal);
  }

  void StateReload() {
    print("State reload");
    bool todayDate = (selectedDate.toString().substring(0, 10) ==
            DateTime.now().toString().substring(0, 10))
        ? true
        : false;
    mealTimeLists =
        (todayDate == true) ? Today_mealTimeLists : NotToday_mealTimeLists;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new meal"),
        backgroundColor: ThemeInfo.primaryColor,
        actions: [
          GestureDetector(
            onTap: () {
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
                  print(val);
                  StateReload();
                },
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: const Text(
              "Meal Time",
              style: TextStyle(fontSize: 20),
            ),
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
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                isEmpty: selectedMealTime == '',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text('Please select a meal time'),
                    value: selectedMealTime,
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMealTime = newValue;
                        print(selectedMealTime);
                        // getFoodData(selectedMeal!);
                        state.didChange(newValue);
                        StateReload();
                      });
                    },
                    items: mealTime.map((String value) {
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
            height: 5,
          ),
          Center(
            child: const Text(
              "Meal Type",
              style: TextStyle(fontSize: 20),
            ),
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
                    borderRadius: BorderRadius.circular(10.0),
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
                        getFoodData(selectedMeal!);
                        state.didChange(newValue);
                        StateReload();
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
          for (Map meal in mealList)
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
