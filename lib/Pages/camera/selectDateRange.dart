import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/Theme/theme_info.dart';

import 'listOfImagesFromDates.dart';

//import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// Daterange class to display the date range picker

class Daterange extends StatefulWidget {
  const Daterange({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

/// State for MyApp
class MyAppState extends State<Daterange> {
  DateTimeRange? _selectedDateRange;

  // This function will be triggered when the floating button is pressed
  Future<void> show() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      currentDate: DateTime.now(),
      saveText: 'Done',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: ThemeInfo.primaryColor,
              //onPrimary: ThemeInfo.,
              //surface: ThemeInfo.primaryColor,
              //onSurface: ThemeInfo.primaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.white, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      // Rebuild the UI
      print(result.start.toString());
      setState(() {
        _selectedDateRange = result;
      });
    }
  }

  bool check() {
    final date1 = _selectedDateRange?.start;
    final date2 = _selectedDateRange?.end;
    final difference = date2?.difference(date1!).inDays;
    print(difference);
    //listofurlsaccordingtoDates(getnextdates());
    if (difference! > 7) {
      Fluttertoast.showToast(
        msg: "maximum gap between date is 7",
      );
      return false;
    }
    return true;
  }

  List<String> getnextdates() {
    List<String> datelist = [];
    var date = _selectedDateRange?.start;
    datelist.add(date.toString().split(' ')[0]);
    var nextdate = date?.add(new Duration(days: 1));
    var finaldate = _selectedDateRange?.end.add(new Duration(days: 1));
    while (finaldate != nextdate) {
      datelist.add(nextdate.toString().split(' ')[0]);
      date = nextdate;
      nextdate = date?.add(new Duration(days: 1));
    }
    //datelist.add(nextdate);
    print(datelist);
    return datelist;
  }

  // void listofurlsaccordingtoDates(List<String> datelist){
  //   final imageStorage staorage = imageStorage();
  //   List<String> urlLit= [];
  //   for (var date in datelist) {
  //     print(staorage.allImagesListofADate(date));
  //   }
  //
  // }
  List<String> mealTimes = [];
  bool breakfast = false;
  bool Morning_Snacks = false;
  bool Lunch = false;
  bool Evening_Snacks = false;
  bool Dinner = false;
  bool Others = false;

  void checkBoxbreakfast(bool? checkBoxState) {
    if (checkBoxState != null) {
      breakfast = checkBoxState;
      setState(() {
        if (breakfast == true) {
          mealTimes.add("Breakfast");
        } else {
          mealTimes.remove("Breakfast");
        }
        print(mealTimes);
      });
    }
  }

  void checkBoxMorning_Snacks(bool? checkBoxState) {
    if (checkBoxState != null) {
      setState(() {
        Morning_Snacks = checkBoxState;
        if (Morning_Snacks == true) {
          mealTimes.add("Morning Snacks");
        } else {
          mealTimes.remove("Morning Snacks");
        }
        print(mealTimes);
      });
    }
  }

  void checkBoxLunch(bool? checkBoxState) {
    if (checkBoxState != null) {
      setState(() {
        Lunch = checkBoxState;
        if (Lunch == true) {
          mealTimes.add("Lunch");
        } else {
          mealTimes.remove("Lunch");
        }
        print(mealTimes);
      });
    }
  }

  void checkBoxEvening_Snacks(bool? checkBoxState) {
    if (checkBoxState != null) {
      setState(() {
        Evening_Snacks = checkBoxState;
        if (Evening_Snacks == true) {
          mealTimes.add("Evening Snacks");
        } else {
          mealTimes.remove("Evening Snacks");
        }
        print(mealTimes);
      });
    }
  }

  void checkBoxDinner(bool? checkBoxState) {
    if (checkBoxState != null) {
      setState(() {
        Dinner = checkBoxState;
        if (Dinner == true) {
          mealTimes.add("Dinner");
        } else {
          mealTimes.remove("Dinner");
        }
        print(mealTimes);
      });
    }
  }

  void checkBoxOthers(bool? checkBoxState) {
    if (checkBoxState != null) {
      setState(() {
        Others = checkBoxState;
        if (Others == true) {
          mealTimes.add("Other meals");
        } else {
          mealTimes.remove("Other Meals");
        }
        print(mealTimes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, //AppBar(title: const Text('KindaCode.com')),
      body: _selectedDateRange == null
          ? Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //const Text('Press the button to show the picker'),
                  MaterialButton(
                    elevation: 10,
                    hoverElevation: 100,
                    focusElevation: 50,
                    highlightElevation: 0,
                    color: ThemeInfo.primaryColor,
                    //color: Colors.white,
                    child: const Text("Pick date range",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                    onPressed: show,
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  const Text(
                    "Start date:",
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  // End date
                  const Text("End date:",
                      style: TextStyle(fontSize: 24, color: Colors.black)),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ))
          : Padding(
              padding: const EdgeInsets.all(30),
              child: ListView(
                // children: Column(
                //   crossAxisAlignment:  CrossAxisAlignment.stretch,
                children: [
                  MaterialButton(
                    elevation: 10,
                    hoverElevation: 100,
                    focusElevation: 50,
                    highlightElevation: 0,
                    color: Colors.black12,
                    //color: Colors.white,
                    child: const Text("Pick date range",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                    onPressed: show,
                  ),
                  const SizedBox(
                    height: 110,
                  ),
                  // Start date
                  Text(
                    "Start date: ${_selectedDateRange?.start.toString().split(' ')[0]}",
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  // End date
                  Text(
                      "End date: ${_selectedDateRange?.end.toString().split(' ')[0]}",
                      style:
                          const TextStyle(fontSize: 24, color: Colors.black)),
                  const SizedBox(
                    height: 50,
                  ),
                  CheckboxListTile(
                      //controlAffinity: ListTileControlAffinity.trailing,
                      //secondary: const Icon(Icons.alarm),
                      title: const Text('Breakfast'),
                      //subtitle: Text('Ringing after 12 hours'),
                      value: breakfast,
                      onChanged: checkBoxbreakfast),

                  CheckboxListTile(
                      //controlAffinity: ListTileControlAffinity.trailing,
                      // secondary: const Icon(Icons.alarm),
                      title: const Text('Morning Snacks'),
                      //subtitle: Text('Ringing after 12 hours'),
                      value: Morning_Snacks,
                      onChanged: checkBoxMorning_Snacks),
                  CheckboxListTile(
                      //controlAffinity: ListTileControlAffinity.trailing,
                      //secondary: const Icon(Icons.alarm),
                      title: const Text('Lunch'),
                      //subtitle: Text('Ringing after 12 hours'),
                      value: Lunch,
                      onChanged: checkBoxLunch),
                  CheckboxListTile(
                      //controlAffinity: ListTileControlAffinity.trailing,
                      // secondary: const Icon(Icons.alarm),
                      title: const Text('Evening Snacks'),
                      //subtitle: Text('Ringing after 12 hours'),
                      value: Evening_Snacks,
                      onChanged: checkBoxEvening_Snacks),
                  CheckboxListTile(
                      //controlAffinity: ListTileControlAffinity.trailing,
                      // secondary: const Icon(Icons.alarm),
                      title: const Text('Dinner'),
                      //subtitle: Text('Ringing after 12 hours'),
                      value: Dinner,
                      onChanged: checkBoxDinner),
                  CheckboxListTile(
                      //controlAffinity: ListTileControlAffinity.trailing,
                      // secondary: const Icon(Icons.alarm),
                      title: const Text('Other Meals'),
                      // subtitle: Text('Ringing after 12 hours'),
                      value: Others,
                      onChanged: checkBoxOthers),
                  const SizedBox(
                    height: 100,
                  ),
                ],
                // ),
              ),
            ),
      // This button is used to show the date range picker
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (check()) {
            Navigator.of(context).push(MaterialPageRoute(builder: (contex) {
              //return CameraScreen(widget.cameras);
              return ScrollViewlistAccordingToDates(getnextdates(), mealTimes);
            }));
          }
        },
        child: const Icon(Icons.search_rounded),
        backgroundColor: ThemeInfo.primaryColor,
      ),
    );
  }
}
