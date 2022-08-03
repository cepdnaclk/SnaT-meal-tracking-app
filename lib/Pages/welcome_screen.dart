import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/login_screen.dart';
import 'package:mobile_app/Services/custom_page_route.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:mobile_app/constants.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../Components/app_logo_text.dart';

User? user = FirebaseAuth.instance.currentUser;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int screenNo = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeInfo.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: height * 4 / 5,
            child: PageView.builder(
                itemCount: landingPageItems.length,
                onPageChanged: (index) {
                  setState(() {
                    screenNo = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                          decoration: const BoxDecoration(
                              //color: Color(0xFFFEFFFA),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15))),
                          height: height * 2 / 3,
                          child: SizedBox(
                            height: height * 2 / 3,
                            width: width,
                            child: SimpleShadow(
                              child: Image.asset(
                                landingPageItems[index]['image'],
                                fit: BoxFit.fitHeight,
                                height: height * 2 / 3,
                                width: width,
                              ),
                              opacity: 0.6, // Default: 0.5
                              color: Colors.black, // Default: Black
                              offset:
                                  const Offset(5, 5), // Default: Offset(2, 2)
                              sigma: 7, // Default: 2
                            ),
                          )),
                      Expanded(
                        child: Center(
                          child: Text(
                            landingPageItems[index]['text'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
          SizedBox(
            height: height / 5,
            width: width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < landingPageItems.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          width: screenNo == i ? 20 : 10,
                          height: 10,
                        ),
                      )
                  ],
                ),
                const Spacer(),
                Center(
                    child: screenNo == 2
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                CustomPageRoute(
                                  child: const LoginScreen(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                "Continue",
                                style: TextStyle(fontSize: 18),
                              ),
                            ))
                        : const AppLogoText(
                            color: Colors.white,
                          )),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
