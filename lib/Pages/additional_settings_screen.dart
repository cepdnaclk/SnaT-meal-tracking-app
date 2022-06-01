import 'package:flutter/material.dart';
import 'package:mobile_app/Components/drop_down.dart';
import 'package:mobile_app/constants.dart';

import '../Services/custom_page_route.dart';
import 'dashboard_layout.dart';

class AdditionalSettingsScreen extends StatelessWidget {
  AdditionalSettingsScreen({Key? key}) : super(key: key);
  String? name;
  int age = 0;
  String? gender;
  int height = 0;
  int weight = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Name:",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Age:",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 5,
          ),
          CountAdder(
            onChanged: (val) {
              age = val;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Gender:",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 5,
          ),
          DropDownWidget(
            items: genderList,
            onChanged: (val) {
              print(val);
              gender = val;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Height (cm) :",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 5,
          ),
          CountAdder(
            onChanged: (val) {
              height = val;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Weight (kg) :",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 5,
          ),
          CountAdder(
            onChanged: (val) {
              weight = val;
            },
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
              onPressed: (){
                print("Hello");
                Navigator.of(context).push(CustomPageRoute(
                    child: DashboardLayout(),
                    transition: "slide right"));
              },
              child: const Padding(
                  padding: EdgeInsets.symmetric(
                  vertical: 15.0, horizontal: 2),
                  child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 20),
      ),
    ),),
        ],
      ),
    );
  }
}

class CountAdder extends StatefulWidget {
  const CountAdder({
    Key? key,
    required this.onChanged,
  }) : super(key: key);
  final Function onChanged;

  @override
  State<CountAdder> createState() => _CountAdderState();
}

class _CountAdderState extends State<CountAdder> {
  int count = 0;
  TextEditingController countController = TextEditingController();

  @override
  void initState() {
    super.initState();
    countController.text = count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
          border: Border.all(width: 1), borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: countController,
              onChanged: (val) {
                count = int.parse(val);
                widget.onChanged(count);
              },
              keyboardType: TextInputType.number,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    count++;
                    countController.text = count.toString();
                    widget.onChanged(count);
                    setState(() {});
                  },
                  child: Container(
                    width: 50,
                    child: const Icon(Icons.keyboard_arrow_up),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 1),
                        bottom: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (count > 0) {
                      count--;
                      countController.text = count.toString();
                      widget.onChanged(count);
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: 50,
                    child: const Icon(Icons.keyboard_arrow_down),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
