import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/login_screen.dart';
import 'package:mobile_app/Services/custom_page_route.dart';
import 'package:mobile_app/Theme/theme_info.dart';

import '../Components/app_logo_text.dart';
import '../main.dart';

class WelcomeScreen extends StatefulWidget {
  //const WelcomeScreen({Key? key}) : super(key: key);
  var cameras;
  WelcomeScreen(this.cameras);
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      timer.cancel();
      Navigator.of(context).push(
          CustomPageRoute(child: LoginScreen(widget.cameras), transition: "slide left"));
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => DashboardLayout()));
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
