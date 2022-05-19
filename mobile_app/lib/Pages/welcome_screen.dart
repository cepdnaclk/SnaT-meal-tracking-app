import 'package:flutter/material.dart';
import 'package:mobile_app/Theme/theme_info.dart';

import '../Components/app_logo_text.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

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
