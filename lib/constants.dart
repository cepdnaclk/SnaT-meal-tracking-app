// Text
import 'package:flutter/material.dart';

String appName = "SnaT";
String introduction =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
    "Nulla quam velit, vulputate eu pharetra nec, mattis ac neque. "
    "Duis vulputate commodo lectus, ac blandit";

String weekChartText = "Total intake for this week";
String dailyChartText = "Total intake for today";

// Add new meal Screen
String addNewMealTitle = "Add new meal";
String saveButton = "Save";
String dateAndTime = "Date";
String mealTime = "Meal Time";
String mealTimeDropdownHint = "Please select a meal time";
String mealTimeDropdownErrorMessage =
    "Please select a meal time before adding food.";
String mealType = "Meal Type";
String mealTypeDropdownHint = "Please select a meal type";
String mealTypeDropdownErrorMessage =
    "Please select a meal type before adding food.";
String addFoodButton = "Add a New Food";
String mealItems = "Meal items";
String noFoodMessage = "No food items added 🙁";

// Add a new food screen
String addNewFoodTitle = "Add a New Food";
String servingAmountText = "Enter the amount";

// Icons

// Add new meal Screen
IconData datePickerIcon = Icons.calendar_today_sharp;

// Add new meal Screen
IconData searchIcon = Icons.search;

//

// Images

String loginImage = "assets/images/login.jpg";
String disappointedImage = "assets/images/sad2.gif";
String sadImage = "assets/images/sad1.gif";
String happyImage = "assets/images/happy0.gif";

// General Variables

List<String> genderList = ["Male", "Female"];

List<String> meals = [
  "Cereals and starchy foods",
  "Vegetables",
  "Fruits",
  "Pulses meat fish",
  "Beverages",
  "Milk and milk products",
  "Nuts and Oil",
  "Fat,Sugar and Salt",
  "Alcoholic Beverages",
];

Map<String, List<int>> limits = {
  "Cereals and starchy foods": [6, 11],
  "Vegetables": [3, 5],
  "Fruits": [2, 3],
  "Pulses meat fish": [3, 4],
  "Beverages": [8, 8],
  "Milk and milk products": [1, 2],
  "Nuts and Oil": [2, 4],
  "Fat,Sugar and Salt": [1, 1],
  "Alcoholic Beverages": [1, 1],
};

List<String> mealTimes = [
  "Breakfast",
  "Morning Snacks",
  "Lunch",
  "Evening Snacks",
  "Dinner",
  "Others"
];
