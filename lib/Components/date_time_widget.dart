import 'package:flutter/material.dart';

class DateTimeWidget extends StatefulWidget {
  const DateTimeWidget(
      {Key? key,
      required this.iconPic,
      required this.text,
      required this.onPressed})
      : super(key: key);
  final Icon iconPic;
  final String text;
  final onPressed;

  @override
  _DateTimeWidgetState createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.text,
          style: const TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        IconButton(
          iconSize: 30,
          color: Colors.black,
          icon: widget.iconPic,
          hoverColor: Colors.purpleAccent,
          onPressed: widget.onPressed,
        ),
      ],
    );
  }
}
