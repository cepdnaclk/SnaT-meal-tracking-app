
class imageinfor {
  late String dateAndTime ;
  late String date;


  bool isAvailable(dateAndTime){
    date = dateAndTime.toString().split(' ')[0];
    DateTime now = new DateTime.now();
    String datemonth = date.split('-')[1];
    print("==>"+datemonth+"  "+ now.month.toString());
    //DateTime todate = new DateTime(now.year, now.month, now.day);
   // String today = todate.toString();
    if (now.month-1>=int. parse(datemonth)){
      print("true");
      return true;
    }
    print("false");
    return false;


  }
}