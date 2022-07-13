import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/dashboard_layout.dart';
import 'package:mobile_app/Pages/login_screen.dart';
import 'package:mobile_app/Services/custom_page_route.dart';
import 'package:mobile_app/Theme/theme_info.dart';

import '../Components/app_logo_text.dart';

User? user = FirebaseAuth.instance.currentUser;

class WelcomeScreen extends StatefulWidget {
  //const WelcomeScreen({Key? key}) : super(key: key);
  WelcomeScreen();
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  checkAuthentification() async {
    if (user != null) {
      Navigator.of(context).push(CustomPageRoute(child: DashboardLayout()));
    } else {
      Navigator.of(context).push(CustomPageRoute(child: const LoginScreen()));
    }
  }

  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      timer.cancel();
      //Navigator.of(context).push(
      //    CustomPageRoute(child: LoginScreen(), transition: "slide left"));
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => DashboardLayout()));
      checkAuthentification();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeInfo.primaryColor,
      body: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 5 * height / 8,
            width: width,
            child: const Center(child: AppLogoText()),
          ),
        ],
      ),
    );
  }
}
