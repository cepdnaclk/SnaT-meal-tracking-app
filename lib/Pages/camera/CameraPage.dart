import 'dart:async';
import 'dart:io';

//import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/Services/IamageStoreService.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobile_app/Settings/ChangeAppLanguage.dart';

import '../../Components/date_time_widget.dart';
import '../../Services/DateTime.dart';
import '../../Theme/theme_info.dart';
import '../../constants.dart';
import '../add_a_meal_screen.dart';

XFile? takedimage;
String? filePath;
class campage extends StatefulWidget {
  campage(XFile imagepicked, String imagepath, this.title){
    takedimage =imagepicked;
    filePath = imagepath;
  }
  final String title;
  @override
  State<campage> createState() => _campageState();
}

class _campageState extends State<campage> {
  DateTime selectedDate = DateTime.now();
  File? image; //= takedimage as File?;
  String? path;
  XFile? new_IMAGE ;//= takedimage ;
  String? filePath;
  bool saved = true;
  late String dateSelected = "";
  late String MealTime = "Other Meals";
  bool mealtimeselected = false;

  final imageStorage staorage = imageStorage();
  final ImagePicker picker = ImagePicker();

  late String imageurlFromFireStore;

  // for save the image
  Future<void> saveimages(String filePath, XFile image) async {
    print("++++++++++" + mealtimeselected.toString());
    if (mealtimeselected == true) {
      Fluttertoast.showToast(
        msg: "Please wait",
      );
      final now = DateTime.now(); // date and time of the moment
      print(filePath);
      String filepath =
          '$filePath/' + now.toString() + '.png'; // make now as image name
      final File newImage =
          await File(image.path).copy('$filePath/' + now.toString() + '.png');
      imageurlFromFireStore =
          await staorage.uploadFile(filepath, now.toString() + ".png");
      print(imageurlFromFireStore);

      await staorage
          .setImageUrl(selectedDate.toString().split(' ')[0], MealTime,
              imageurlFromFireStore)
          .then(
            (value) => Fluttertoast.showToast(
              msg: "The_image_saved",
            ),
          );

      if (image == null) return;
      setState(() {
        image = (newImage as XFile?)!;
      });
    } else {
      Fluttertoast.showToast(
        msg: "Please_select_meal_time".tr,
      );
    }
  }

  void StateReload() {
    print("==============================");
    print("State reload");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        child: const Icon(Icons.save),
        backgroundColor: ThemeInfo.primaryColor,
        onPressed: () {
          if (saved) {
            if (new_IMAGE != null) {
              saveimages(filePath!, new_IMAGE!); // working
              saved = false;
            }
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Text(
                    "Date_and_time:".tr,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ]),
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
                setState(() {});
              },
            ),
            const SizedBox(
              height: 40,
            ),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    //labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  isEmpty: selectedMealTime == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text('Please_select_meal_time'.tr),
                      value: selectedMealTime,
                      isDense: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          mealtimeselected = true;
                          selectedMealTime = newValue;
                          MealTime = newValue!;
                          print(selectedMealTime);
                          // getFoodData(selectedMeal!);
                          state.didChange(newValue);
                          StateReload();
                          Fluttertoast.showToast(
                            msg: MealTime,
                          );
                        });
                      },
                      items: mealTimes.map((String value) {
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
            const SizedBox(
              height: 20,
            ),
            //Image.file(new_IMAGE as File),
            image != null
                ? Image.file(takedimage as File) //(image!)
                : const Center(
                    heightFactor: 2.2,
                    child: Icon(
                      Icons.food_bank,
                      size: 180,
                      color: Color.fromARGB(100, 125, 156, 139),
                    ),
                  ),
          ],
          //   ),
          //   //child: raw(),
          // ),
        ),
      ),
    );
  }
}
