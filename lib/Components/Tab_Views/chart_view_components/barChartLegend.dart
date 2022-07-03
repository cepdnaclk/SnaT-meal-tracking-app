import 'package:flutter/material.dart';

class BoxLegend extends StatelessWidget {
  final String text;
  final Color colour;
  const BoxLegend({
    Key? key,
    required this.text,
    required this.colour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: colour,
          ),
        ),
        const SizedBox(
          width: 7.0,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }
}
