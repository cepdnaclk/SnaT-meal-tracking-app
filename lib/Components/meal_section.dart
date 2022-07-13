import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/add_a_meal_screen.dart';

class MealSection extends StatefulWidget {
  const MealSection({Key? key, required this.label, this.mealItems})
      : super(key: key);
  final String label;
  final List? mealItems;

  @override
  _MealSectionState createState() => _MealSectionState();
}

class _MealSectionState extends State<MealSection> {
  bool showBreakfast = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Material(
        elevation: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(2.0, 2.0),
                      color: Colors.grey.shade500,
                      blurRadius: 15,
                      spreadRadius: 1),
                  const BoxShadow(
                      offset: Offset(-4.0, -4.0),
                      color: Colors.white,
                      blurRadius: 15,
                      spreadRadius: 1),
                ],
                color: Colors.teal,
              ),
              child: Row(
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                      showBreakfast = !showBreakfast;
                      print(showBreakfast);
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            if (showBreakfast)
              const SizedBox(
                height: 5,
              ),
            if (widget.mealItems!.isEmpty)
              if (showBreakfast)
                Column(
                  children: [],
                ),
            if (widget.mealItems!.isNotEmpty)
              for (int i = 0; i < widget.mealItems!.length; i++)
                if (showBreakfast)
                  Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/food.jfif",
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.mealItems![i]['name']),
                              Text(widget.mealItems![i]['amount']),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_vert))
                        ],
                      ),
                      const Divider(
                        height: 8,
                      ),
                    ],
                  ),
            if (showBreakfast)
              const SizedBox(
                height: 5,
              ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      )
    ]);
  }
}
