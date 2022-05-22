import 'package:flutter/material.dart';
import 'package:mobile_app/Services/DateTime.dart';
import 'package:mobile_app/Theme/theme_info.dart';

import '../Components/date_time_widget.dart';

class AddAMealScreen extends StatefulWidget {
  const AddAMealScreen({Key? key}) : super(key: key);

  @override
  State<AddAMealScreen> createState() => _AddAMealScreenState();
}

class _AddAMealScreenState extends State<AddAMealScreen> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new meal"),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text("Save"),
            )),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
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
            text: DateTimeService.dateConverter(selectedDate),
            onPressed: () async {
              selectedDate = await showDatePicker(
                    context: context,
                    builder: (context, child) => Theme(
                      data: ThemeData().copyWith(
                        colorScheme:
                            ColorScheme.light(primary: ThemeInfo.primaryColor),
                      ),
                      child: child!,
                    ),
                    initialDate: selectedDate,
                    firstDate: DateTime(2022, 01, 01),
                    lastDate: DateTime.parse('2023-09-01'),
                  ) ??
                  selectedDate;

              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
