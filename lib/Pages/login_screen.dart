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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/login1.png",
                width: MediaQuery.of(context).size.width * 3 / 7,
              ),
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 7 / 24,
                    width: MediaQuery.of(context).size.width / 9,
                    child: Image.asset(
                      "assets/images/login2.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              const Spacer(),
              Image.asset(
                "assets/images/login_main_landscape.png",
              ),
              Center(
                child: Text(
                  "SnaT",
                  style: TextStyle(
                    color: const Color(0xff53a09e),
                    fontSize: 90,
                    //fontWeight: FontWeight.bold,
                    fontFamily: ThemeInfo.logoFontFamily,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "Snap and Track",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Times new roman",
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                child: Text(
                  "Experience next level food tracking with photos, emojis, and fun-filled food journaling... Your way to a balanced meal is just a click or two away...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Times new roman",
                    color: Colors.grey[700],
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
                    ElevatedButton(
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
                            color: Colors.black,
                          )),
                      style: ElevatedButton.styleFrom(
                        primary: ThemeInfo.bottomTabButtonColor,
                        shadowColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 50.0),
                    ElevatedButton(
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
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: ThemeInfo.bottomTabButtonColor,
                        shadowColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              const Text('OR',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () async {
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
                          child: DashboardLayout(),
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff53a09e),
                      borderRadius: BorderRadius.circular(10),
                    ),
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
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
