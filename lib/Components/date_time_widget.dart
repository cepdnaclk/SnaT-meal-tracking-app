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
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6.5),
        decoration: BoxDecoration(
          //color: Colors.green[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black54, width: 0.6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisSize: MainAxisSize.min,
          children: [
            /*IconButton(
              iconSize: 25,
              color: Colors.black,
              icon: widget.iconPic,
              hoverColor: Colors.purpleAccent,
              onPressed: () async {
                selectedDate = await showDatePicker(
                      context: context,
                      builder: (context, child) => Theme(
                        data: ThemeData().copyWith(
                          colorScheme: ColorScheme.light(
                              primary: ThemeInfo.primaryColor),
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
            ),*/
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            IconButton(
              padding: const EdgeInsets.only(right: 5),
              iconSize: 23,
              alignment: Alignment.centerRight,
              color: Colors.black54,
              icon: widget.iconPic,
              hoverColor: Colors.purpleAccent,
              onPressed: () async {
                selectedDate = await showDatePicker(
                      context: context,
                      builder: (context, child) => Theme(
                        data: ThemeData().copyWith(
                          colorScheme: ColorScheme.light(
                              primary: ThemeInfo.primaryColor),
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
        ),
      ),
    );
  }
}
