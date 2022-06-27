import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/additional_settings_screen.dart';
import 'package:mobile_app/Pages/dashboard_layout.dart';
import 'package:mobile_app/Services/custom_page_route.dart';
import 'package:mobile_app/Services/firebase_services.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/Pages/register_page.dart';


import '../main.dart';

class LoginScreen extends StatelessWidget {
  //const LoginScreen({Key? key}) : super(key: key);
  LoginScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: ThemeInfo.primaryColor,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(loginImage,
                            width: MediaQuery.of(context).size.width - 60,
                            height: MediaQuery.of(context).size.width - 60),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          introduction,
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -25,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseServices().signInWithGoogle();
                        print("Hello");
                        Navigator.of(context).push(CustomPageRoute(
                            //child: DashboardLayout(),
                            //child: AdditionalSettingsScreen(),
                            child: RegisterPage(),
                            transition: "slide right"));
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10),
                        child: Text(
                          "Sign in with Google",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            flex: 10,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Text(
                    "Terms & Conditions",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            flex: 3,
          )
        ],
      ),
    );
  }
}
