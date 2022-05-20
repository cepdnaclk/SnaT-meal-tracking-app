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
}
