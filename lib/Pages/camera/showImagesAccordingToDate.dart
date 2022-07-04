/*
 this is for show images according to date
 first user have to choose the date meal time then push search button
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_app/Services/IamageStoreService.dart';

import '../../Components/date_time_widget.dart';
import '../../Services/DateTime.dart';
import '../../Theme/theme_info.dart';
import '../add_a_meal_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'listOfImagesAccordingToDate.dart';

class selectDateShowImage extends StatefulWidget {
  const selectDateShowImage({Key? key}) : super(key: key);

  @override
  _selectDateShowImageState createState() => _selectDateShowImageState();
}

class _selectDateShowImageState extends State<selectDateShowImage> {
  DateTime selectedDate = DateTime.now();
  File? image;
  late String MealTime ="non";
  List<String> urlList = [];

  final imageStorage staorage = imageStorage();


  void StateReload() {
    print("State reload");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:null,

      floatingActionButton: FloatingActionButton(
        heroTag: "btn6",
        child: const Icon(Icons.search_rounded),
        backgroundColor: ThemeInfo.primaryColor,
        onPressed: (){
          //search();
          if (MealTime!="non") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (contex) { //return CameraScreen(widget.cameras);
                  return listAccordingToDate(
                      selectedDate.toString().split(' ')[0], MealTime);
                })
            );
          }
          else{
            // add a toast here
          }
        },
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              const Text(
                "select DATE & MEALTIME",
                textAlign:TextAlign.left,
                //color:;
                style: TextStyle(fontSize: 20,color: Colors.red),
              ),
              const SizedBox(height: 40,),

              const Text(
                "Date and time:",
                style: TextStyle(fontSize: 20),
              ),

              DateTimeWidget(
                iconPic: const Icon(
                  Icons.calendar_today,
                ),
                selectedDate: selectedDate,
                text: DateTimeService.dateConverter(selectedDate),
                onPressed: (val) async {
                  selectedDate = val;
                  //dateSelected = val.toSring();
                  print(selectedDate);
                  //print(dateSelected);
                  print(val);
                  setState(() {});
                },
              ),
              const SizedBox(height: 20,),

              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      //labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    isEmpty: selectedMealTime == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Text('Please select a meal time'),
                        value: selectedMealTime,
                        isDense: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMealTime = newValue!;
                            MealTime = newValue;
                            //mealtime = selectedMealTime!;
                            print(selectedMealTime);
                            // getFoodData(selectedMeal!);
                            state.didChange(newValue);
                            StateReload();

                          });
                        },
                        items: mealTime.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],

          ),
        ],
      ),
    );
  }

}
