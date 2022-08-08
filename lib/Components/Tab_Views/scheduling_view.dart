import 'package:flutter/material.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulingView extends StatefulWidget {
  const SchedulingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Scheduling View");
  }

  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<SchedulingView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  final kToday = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      // AppBar(
      //     automaticallyImplyLeading:false,
      //   //title: Text('TableCalendar - Basics'),
      // ),
      body: TableCalendar(
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
              color: _focusedDay.toString().substring(0, 11) ==
                      kToday.toString().substring(0, 11)
                  ? ThemeInfo.primaryColor
                  : ThemeInfo.secondaryColor,
              shape: BoxShape.circle),
          selectedDecoration: BoxDecoration(
              color: ThemeInfo.primaryColor, shape: BoxShape.circle),
        ),
        firstDay: DateTime(1970),
        lastDay: DateTime(2070),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
      ),
    );
  }
}
