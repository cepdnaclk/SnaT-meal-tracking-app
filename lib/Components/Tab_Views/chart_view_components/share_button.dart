import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({Key? key, required this.press}) : super(key: key);

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Share',
        style: TextStyle(fontSize: 14.0),
      ),
      color: Colors.teal.shade900,
      textColor: Colors.white,
      onPressed: press,
    );
  }
}
