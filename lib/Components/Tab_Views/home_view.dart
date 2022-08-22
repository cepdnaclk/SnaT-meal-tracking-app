import 'package:flutter/material.dart';
import 'package:mobile_app/Components/meal_section.dart';
import 'package:mobile_app/Models/food_model.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';
import 'package:mobile_app/Services/DateTime.dart';
import 'package:mobile_app/Services/firebase_services.dart';
import 'package:mobile_app/Theme/theme_info.dart';

import '../../Services/custom_page_route.dart';

Map todayMeals = {};
Map<String, List<FoodModel>> foodsData = {};

class HomeView extends StatefulWidget {
  const HomeView({Key? key, required this.isDone}) : super(key: key);
  final bool isDone;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<Map> _fetchData;
  @override
  void initState() {
    super.initState();

    _fetchData = FirebaseServices.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeInfo.primaryColor,
        onPressed: () {
          Navigator.of(context).push(
            CustomPageRoute(
              child: AddAMealScreen(
                onChanged: () {
                  setState(() {
                    _fetchData = FirebaseServices.fetchData();
                  });
                },
              ),
              transition: "scale",
            ),
          );
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
            FutureBuilder(
              future: _fetchData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    widget.isDone) {
                  todayMeals = snapshot.data as Map;
                  return Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (String key in todayMeals.keys)
                          MealSection(
                            label: key,
                            mealItems: todayMeals[key],
                          ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
