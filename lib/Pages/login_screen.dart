import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/register_page.dart';
import 'package:mobile_app/Services/custom_page_route.dart';
import 'package:mobile_app/Services/firebase_services.dart';
import 'package:mobile_app/Theme/theme_info.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe2fbf8),
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
              Image.asset("assets/images/login_main_landscape.png"),
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
                child: GestureDetector(
                  onTap: () async {
                    await FirebaseServices().signInWithGoogle();
                    print("Hello");
                    Navigator.of(context).push(CustomPageRoute(
                        child: const RegisterPage(),
                        transition: "slide right"));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xff53a09e),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Sign in with Google",
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
