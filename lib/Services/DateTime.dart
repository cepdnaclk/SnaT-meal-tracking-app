import 'package:flutter/material.dart';

class DateTimeService {
  static List months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  static String dateComponent(int date) {
    if (date == 1 || date == 21 || date == 31) {
      return 'st';
    } else if (date == 2 || date == 22) {
      return 'nd';
    } else if (date == 3 || date == 23) {
      return 'rd';
    } else {
      return "th";
    }
  }

  static String getDateString(DateTime date) {
    String dateString = date.day.toString() +
        dateComponent(date.day) +
        " of " +
        months[date.month - 1] +
        ', ' +
        date.year.toString();

    return dateString;
  }

  static dateConverter(DateTime date) {
    //2021-12-09 12:08:43.546

    List dateList = date.toString().split(' ')[0].split('-');
    //09-12-2021
    String formattedDate = dateList[2] + '-' + dateList[1] + '-' + dateList[0];

    return formattedDate;
  }

  static timeConverter(TimeOfDay timeOfDay) {
    String hourString = int.parse('${timeOfDay.hour}') <= 9
        ? '0${timeOfDay.hour}'
        : '${timeOfDay.hour}';
    String minuteString = int.parse('${timeOfDay.minute}') <= 9
        ? '0${timeOfDay.minute}'
        : '${timeOfDay.minute}';

    DateTime timeDate =
        DateTime.parse('2021-10-10 $hourString:$minuteString:00');
    List timeList = timeDate.toString().split(' ')[1].split(':');
    //05:38 pm
    // String formattedTime =
    //     '${timeOfDay!.hourOfPeriod}:${timeOfDay.minute} ${timeOfDay.periodOffset == 0 ? 'am' : 'pm'}';
    String formattedTime = int.parse(timeList[0]) == 0
        ? '12:${timeList[1]} am'
        : int.parse(timeList[0]) > 12
            ? '${int.parse(timeList[0]) - 12 < 10 ? '0${int.parse(timeList[0]) - 12}' : int.parse(timeList[0]) - 12}:${timeList[1]} pm'
            : int.parse(timeList[0]) == 12
                ? '${timeList[0]}:${timeList[1]} pm'
                : '${timeList[0]}:${timeList[1]} am';
    //String formattedDate = dateList[2] + '-' + dateList[1] + '-' + dateList[0];
    return formattedTime;
  }

  static dateTimeConverterFromString(
      DateTime date, String formattedDate, String formattedTime) {
    //Wednesday 08-12-2021 05:38 pm
    List<String> weekDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    String weekDay = weekDays[date.weekday - 1];

    String formattedDateTime =
        weekDay + ' ' + formattedDate + ' ' + formattedTime;
    return formattedDateTime;
  }

  static hour_24converter(TimeOfDay time) {
    String hourString =
        int.parse('${time.hour}') <= 9 ? '0${time.hour}' : '${time.hour}';
    String minuteString =
        int.parse('${time.minute}') <= 9 ? '0${time.minute}' : '${time.minute}';

    String time_24 =
        hourString.toString() + ":" + minuteString.toString() + ":00.000000";
    return time_24;

    // String time_24 =
    //     time.hour.toString() + ":" + time.minute.toString() + ":00.000000";
    // return time_24;
  }
}
