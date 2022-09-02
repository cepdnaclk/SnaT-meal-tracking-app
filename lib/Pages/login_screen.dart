import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/dashboard_layout.dart';
import 'package:mobile_app/Pages/register_page.dart';
import 'package:mobile_app/Pages/signIn_page.dart';
import 'package:mobile_app/Pages/signUp_page.dart';
import 'package:mobile_app/Pages/welcome_screen.dart';
import 'package:mobile_app/Services/custom_page_route.dart';
import 'package:mobile_app/Services/firebase_services.dart';

import '../Theme/theme_info.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeInfo.loginBGColor,
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            "assets/images/login_bg.png",
            fit: BoxFit.cover,
          )),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo_transparent.png",
                      width: 75,
                      height: 75,
                    ),
                    Text(
                      "SnaT",
                      style: TextStyle(
                        fontSize: 70,
                        color: ThemeInfo.secondaryTextColor,
                        fontWeight: FontWeight.bold,
                        //fontFamily: ThemeInfo.logoFontFamily,
                      ),
                    ),
                  ],
                ),
                const Center(
                  child: Text(
                    "Snap and Track",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Times new roman",
                    ),
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    "assets/images/login_main.png",
                    // width: 250,
                    // height: 250,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                  child: Text(
                    "Experience next level food tracking with photos, emojis, and fun-filled food journaling... Your way to a balanced meal is just a click or two away...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Times new roman",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignIn(),
                            ),
                          );
                        },
                        child: const Text('  Sign In  ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          backgroundColor: const Color(0xff19E6EF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      const SizedBox(width: 50.0),
                      TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ),
                          );
                        },
                        child: const Text(
                          '  Sign Up  ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          backgroundColor: const Color(0xff19E6EF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text('OR',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      backgroundColor: const Color(0xff19E6EF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () async {
                      await FirebaseServices().signInWithGoogle();
                      print("Hello");

                      user = FirebaseAuth.instance.currentUser;
                      String uid;

                      if (user != null) {
                        uid = user!.uid;
                      } else {
                        uid = '';
                      }
                      final snapShot = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .get();
                      if (snapShot.exists) {
                        Navigator.of(context).push(
                          CustomPageRoute(
                            child: const DashboardLayout(),
                            transition: "slide right",
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          CustomPageRoute(
                            child: const RegisterPage(),
                            transition: "slide right",
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Sign in with Google",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
