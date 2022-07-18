import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({Key? key, required this.press}) : super(key: key);

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
        child: Text(
          'Share',
          style: TextStyle(fontSize: 14.0),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.teal.shade900,
      ),
      onPressed: press,
    );
  }
}
