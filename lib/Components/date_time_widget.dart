import 'package:flutter/material.dart';

import '../Theme/theme_info.dart';

class DateTimeWidget extends StatefulWidget {
  const DateTimeWidget(
      {Key? key,
      required this.iconPic,
      required this.text,
      required this.onPressed,
      required this.selectedDate})
      : super(key: key);
  final Icon iconPic;
  final String text;
  final onPressed;
  final selectedDate;

  @override
  _DateTimeWidgetState createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  late DateTime selectedDate;
  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
  }

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
          onPressed: () async {
            selectedDate = await showDatePicker(
                  context: context,
                  builder: (context, child) => Theme(
                    data: ThemeData().copyWith(
                      colorScheme:
                          ColorScheme.light(primary: ThemeInfo.primaryColor),
                    ),
                    child: child!,
                  ),
                  initialDate: selectedDate,
                  firstDate: DateTime(2022, 01, 01),
                  lastDate: DateTime.parse('2023-09-01'),
                ) ??
                selectedDate;
            widget.onPressed(selectedDate);
          },
        ),
      ],
    );
  }
}
