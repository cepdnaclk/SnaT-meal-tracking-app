import 'package:flutter/material.dart';

import 'additional_settings_screen.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdditionalSettingsScreen()));
          },
          child: Text("Next"),
        ),
      ),
    );
  }
}
