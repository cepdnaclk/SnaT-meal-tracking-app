import 'package:flutter/material.dart';
import 'package:mobile_app/Theme/theme_info.dart';

import '../constants.dart';

class AppLogoText extends StatelessWidget {
  const AppLogoText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      appName,
      style: TextStyle(
        fontSize: 80,
        fontFamily: ThemeInfo.logoFontFamily,
      ),
    );
  }
}
