import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Theme/theme_info.dart';

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

  double turns = 0.0;

  void _changeRotation() {
    showBreakfast = !showBreakfast;
    setState(() => showBreakfast ? turns += 1.0 / 2.0 : turns -= 1.0 / 2.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _changeRotation,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ThemeInfo.mealSectionCardColor,
                ),
                child: Row(
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 20,
                        color: ThemeInfo.secondaryTextColor,
                      ),
                    ),
                    const Spacer(),
                    AnimatedRotation(
                      turns: turns,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 30,
                        color: ThemeInfo.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
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
            if (showBreakfast && widget.mealItems!.isNotEmpty)
              for (int i = 0; i < widget.mealItems!.length; i++)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.5, color: Colors.grey[300]!),
                    ),
                  ),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                                "assets/images/${widget.mealItems![i]['type']}.png")),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                widget.mealItems![i]["food"],
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                (widget.mealItems![i]["amount"]
                                                    .toInt()
                                                    .toDouble() ==
                                                widget.mealItems![i]["amount"]
                                            ? widget.mealItems![i]["amount"]
                                                .toInt()
                                            : widget.mealItems![i]["amount"])
                                        .toString() +
                                    ' ' +
                                    widget.mealItems![i]['unit'],
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black54),
                              ),
                              Text(
                                widget.mealItems![i]["type"],
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 11),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
