import 'package:flutter/material.dart';
import 'package:mobile_app/Services/DateTime.dart';

import '../Components/date_time_widget.dart';

class AddAMealScreen extends StatefulWidget {
  const AddAMealScreen({Key? key}) : super(key: key);

  @override
  State<AddAMealScreen> createState() => _AddAMealScreenState();
}

class _AddAMealScreenState extends State<AddAMealScreen> {
  DateTime selectedDate = DateTime.now();

  String? selectedMeal;

  List<String> meals = ["Rice & Curry", "Bread", "Noodles"];
  List mealItems = [
    {"name": "Rice & Curry", "icon": Icons.fastfood},
    {"name": "Bread", "icon": Icons.fastfood},
    {"name": "Tea", "icon": Icons.local_cafe}
  ];

  DropdownButton dropDown(List dropList) {
    List<DropdownMenuItem> dropdownList = [];
    for (String listItem in dropList) {
      var newItem = DropdownMenuItem(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Container(
              height: 32,
              child: Text(listItem),
            ),
          ),
          Divider(
            thickness: 1,
          )
        ]),
        value: listItem,
      );
      dropdownList.add(newItem);
    }
    return DropdownButton(
      dropdownColor: Colors.white,
      iconEnabledColor: Colors.grey,
      value: selectedMeal,
      items: dropdownList,
      onChanged: (value) {
        selectedMeal = value;
        print(selectedMeal);
        setState(() {});
      },
    );
  }

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
            selectedDate: selectedDate,
            text: DateTimeService.dateConverter(selectedDate),
            onPressed: (val) async {
              selectedDate = val;
              setState(() {});
            },
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Meal:",
            style: TextStyle(fontSize: 20),
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
                        borderRadius: BorderRadius.circular(5.0))),
                isEmpty: selectedMeal == '',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text('Please select a meal'),
                    value: selectedMeal,
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMeal = newValue;
                        state.didChange(newValue);
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
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: const Text(
                "Add a food",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Meal items:",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 5,
          ),
          for (Map meal in mealItems)
            Container(
              margin: EdgeInsets.symmetric(vertical: 2),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.black,
              )),
              child: Row(
                children: [
                  Icon(
                    meal["icon"],
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    meal["name"],
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
