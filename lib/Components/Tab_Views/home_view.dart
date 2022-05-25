import 'package:flutter/material.dart';
import 'package:mobile_app/Components/meal_section.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';
import 'package:mobile_app/Services/DateTime.dart';
import 'package:mobile_app/Services/custom_page_route.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  getDate() {}
  @override
  Widget build(BuildContext context) {
    getDate();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
                children: const [
                  MealSection(
                    label: "Breakfast",
                  ),
                  MealSection(
                    label: "Lunch",
                  ),
                  MealSection(
                    label: "Dinner",
                  ),
                  MealSection(
                    label: "Snacks",
                  ),
                  MealSection(
                    label: "Others",
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
