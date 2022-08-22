import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/dashboard_layout.dart';
import 'package:mobile_app/Services/custom_page_route.dart';
import 'package:mobile_app/Theme/theme_info.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
    this.userInfo,
    this.onSaved,
  }) : super(key: key);

  final Map? userInfo;
  final Function? onSaved;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _birthController = TextEditingController();
  final _genderController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _genderController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _nameController.text = widget.userInfo?['name'];
    _birthController.text = widget.userInfo?['dateOfBirth'];
    _genderController.text = widget.userInfo?['gender'];
    _heightController.text = widget.userInfo?['height'];
    _weightController.text = widget.userInfo?['weight'];

    super.initState();
  }

  Future addUserDetails(String name, String birthDate, String gender,
      String height, String weight) async {
    User? user = FirebaseAuth.instance.currentUser;
    String uid;
    var email;
    if (user != null) {
      uid = user.uid;
      email = user.email;
    } else {
      uid = '';
      email = '';
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'birthDate': birthDate,
      'gender': gender,
      'height': height,
      'weight': weight,
      'uid': uid,
      'email': email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: ThemeInfo.secondaryColor,
        appBar: AppBar(
          // elevation: 8.0,
          backgroundColor: ThemeInfo.primaryColor,
          title: const Text("User Details"),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: 10),
              // Text(
              //   'User Details',
              //   style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
              // ),

              Container(
                height: 150,
                child: const Image(
                  image: const AssetImage("assets/images/register_page.jpg"),
                  fit: BoxFit.contain,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ThemeInfo.primaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Name',
                    fillColor: Colors.teal[100],
                    filled: true,
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _birthController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ThemeInfo.primaryColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Date of Birth',
                      fillColor: Colors.teal[100],
                      filled: true,
                      prefixIcon: const Icon(Icons.calendar_month)),
                  onTap: () async {
                    var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101));
                    _birthController.text = date.toString().substring(0, 10);
                  },
                ),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _genderController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ThemeInfo.primaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Gender',
                    fillColor: Colors.teal[100],
                    filled: true,
                    prefixIcon: const Icon(Icons.boy),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _heightController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ThemeInfo.primaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Height (cm)',
                    fillColor: Colors.teal[100],
                    filled: true,
                    prefixIcon: const Icon(Icons.height),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ThemeInfo.primaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Weight (Kg)',
                    fillColor: Colors.teal[100],
                    filled: true,
                    prefixIcon: const Icon(Icons.monitor_weight_rounded),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              ElevatedButton(
                  onPressed: () {
                    if (widget.userInfo == null) {
                      User? user = FirebaseAuth.instance.currentUser;
                      String uid;
                      var email;
                      if (user != null) {
                        uid = user.uid;
                        email = user.email;
                      } else {
                        uid = '';
                        email = '';
                      }
                      addUserDetails(
                        _nameController.text.trim(),
                        _birthController.text.trim(),
                        _genderController.text.trim(),
                        _heightController.text.trim(),
                        _weightController.text.trim(),
                      );
                      Navigator.of(context).push(CustomPageRoute(
                          child: const DashboardLayout(),
                          transition: "slide right"));
                    } else {
                      if (_nameController.text.trim() !=
                              widget.userInfo!['name'] ||
                          _birthController.text.trim() !=
                              widget.userInfo!['dateOfBirth'] ||
                          _genderController.text.trim() !=
                              widget.userInfo!['gender'] ||
                          _heightController.text.trim() !=
                              widget.userInfo!['height'] ||
                          _weightController.text.trim() !=
                              widget.userInfo!['weight']) {
                        addUserDetails(
                          _nameController.text.trim(),
                          _birthController.text.trim(),
                          _genderController.text.trim(),
                          _heightController.text.trim(),
                          _weightController.text.trim(),
                        );
                        widget.onSaved!();
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8),
                    child: Text(
                      widget.userInfo != null
                          ? "Update Information"
                          : "   Let's get started   ",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: ThemeInfo.primaryColor,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ))
            ],
          ),
        )));
  }
}
