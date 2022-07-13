import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Components/meal_section.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';
import 'package:mobile_app/Services/DateTime.dart';
import 'package:mobile_app/Services/custom_page_route.dart';
import 'package:mobile_app/Theme/theme_info.dart';

import '../../Pages/welcome_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  getDate() {}
  void initState() {
    super.initState();
    setState(() {});
  }

  fetchData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection('foodLog')
        .doc(DateTime.now().toString().substring(0, 10))
        .get()
        .then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    print(DateTime.now().toString().substring(0, 10));

    bool todayDate = (selectedDate.toString().substring(0, 10) ==
            DateTime.now().toString().substring(0, 10))
        ? true
        : false;
    print(todayDate);
    getDate();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeInfo.primaryColor,
        onPressed: () {
          Navigator.of(context).push(
              CustomPageRoute(child: AddAMealScreen(), transition: "scale"));
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Meal",
              style: TextStyle(fontSize: 25),
            ),
            Text(DateTimeService.getDateString(DateTime.now())),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  MealSection(
                    label: "Breakfast",
                    mealItems: todayBreakFastMealItems,
                  ),
                  MealSection(
                    label: "Morning Snacks",
                    mealItems: (todayDate == true)
                        ? Today_MorningSnacksMealItems
                        : NotToday_MorningSnacksMealItems,
                  ),
                  MealSection(
                    label: "Lunch",
                    mealItems: (todayDate == true)
                        ? Today_MorningSnacksMealItems
                        : NotToday_LunchMealItems,
                  ),
                  MealSection(
                    label: "Evening Snacks",
                    mealItems: Today_EveningSnacksMealItems,
                  ),
                  MealSection(
                    label: "Dinner",
                    mealItems: Today_DinnerMealItems,
                  ),
                  MealSection(
                    label: "Others",
                    mealItems: Today_OtherMealItems,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
