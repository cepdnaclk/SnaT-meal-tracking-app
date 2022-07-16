import 'package:flutter/material.dart';
import 'package:mobile_app/Components/drop_down.dart';
import 'package:mobile_app/Models/user_model.dart';
import 'package:mobile_app/Pages/login_screen.dart';
import 'package:mobile_app/constants.dart';

import '../Components/count_adder.dart';

class AdditionalSettingsScreen extends StatefulWidget {
  const AdditionalSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AdditionalSettingsScreen> createState() =>
      _AdditionalSettingsScreenState();
}

class _AdditionalSettingsScreenState extends State<AdditionalSettingsScreen> {
  String? name;

  double age = 0;

  String? gender;

  double height = 0;

  double weight = 0;

  final _formKey = GlobalKey<FormState>();

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(
              height: 50,
            ),
            const Center(
                child: Text(
              "Additional Information",
              style: TextStyle(fontSize: 25),
            )),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Name:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              onChanged: (val) {
                name = val;
              },
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Enter your name",
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
              isInt: true,
              hasError:
                  (age <= 0 || age != age.toInt().toDouble()) && showError,
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
              hasError: showError && gender == null,
              items: genderList,
              onChanged: (val) {
                gender = val;
              },
            ),
            if (showError)
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 5),
                child: Text(
                  "Please select a gender",
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 11,
                  ),
                ),
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
              hasError: height <= 0 && showError,
              isInt: false,
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
              hasError: weight <= 0 && showError,
              isInt: false,
              onChanged: (val) {
                weight = val;
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (gender != null &&
                        height > 0 &&
                        weight > 0 &&
                        age > 0 &&
                        age == age.toInt().toDouble()) {
                      UserModel currentUser = UserModel();
                      currentUser.gender = gender;
                      currentUser.weight = weight;
                      currentUser.height = height;
                      currentUser.age = age.toInt();

                      showError = false;
                      setState(() {});
                    } else {
                      showError = true;
                      setState(() {});
                    }
                  }

                  if (gender != null &&
                      height > 0 &&
                      weight > 0 &&
                      age > 0 &&
                      age == age.toInt().toDouble()) {
                    showError = false;
                    setState(() {});
                  } else {
                    showError = true;
                    setState(() {});
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: 18),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
