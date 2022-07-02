import 'dart:io';

import 'package:flutter/material.dart';

import '../../Components/date_time_widget.dart';
import '../../Services/DateTime.dart';
import '../../Theme/theme_info.dart';
import '../add_a_meal_screen.dart';

class selectDateShowImage extends StatefulWidget {
  const selectDateShowImage({Key? key}) : super(key: key);

  @override
  _selectDateShowImageState createState() => _selectDateShowImageState();
}

class _selectDateShowImageState extends State<selectDateShowImage> {
  File? image;
  late String date;
  late String mealtime;
  void StateReload() {
    print("State reload");
    setState(() {});
  }
  void search() async{
    String datepicked = await date;
    String mealtimepicked = await date;
    print(datepicked);
    print(mealtimepicked);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:null,
      // AppBar(
      //   title: const Text("pickn date and meal time"),
      //
      // ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn6",
        child: const Icon(Icons.search_rounded),
        backgroundColor: ThemeInfo.primaryColor,
        onPressed: (){
          search();
        },
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // const Text(
              //   "Date and time:",
              //   style: TextStyle(fontSize: 20),
              // ),
              DateTimeWidget(
                iconPic: const Icon(
                  Icons.calendar_today,
                ),
                selectedDate: selectedDate,
                text: DateTimeService.dateConverter(selectedDate),
                onPressed: (val) async {
                  selectedDate = val;
                  date = selectedDate as String;
                  print(val);
                  setState(() {});
                },
              ),
              // MaterialButton(// Gallery
              //     elevation: 100,
              //     hoverElevation: 100,
              //     focusElevation: 50,
              //     highlightElevation: 50,
              //     color: Colors.black12,
              //     child: const Text(
              //         "Pick from Gallery",
              //         style: TextStyle(
              //           color: Colors.black, fontWeight: FontWeight.bold , fontSize: 15,
              //         )
              //     ),
              //     onPressed: () {
              //       saved=true;
              //       pickImage();
              //     }
              // ),
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
                            mealtime = selectedMealTime!;
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
              const SizedBox(height: 5,),
              image != null ? Image.file(image!): const Icon(Icons.food_bank,size: 380,color:Color.fromARGB(100, 125, 156, 139) ,),

            ],

          ),

        ],
      ),
    );
  }

}
