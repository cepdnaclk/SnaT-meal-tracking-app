import 'dart:async';
import 'dart:io';

//import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/Models/image_model.dart';
import 'package:mobile_app/Pages/welcome_screen.dart';

import '../../Components/date_time_widget.dart';
import '../../Services/DateTime.dart';
import '../../Services/IamageStoreService.dart';
import '../../Theme/theme_info.dart';
import '../../constants.dart';
import '../add_a_meal_screen.dart';



class CamPage extends StatefulWidget {
  const CamPage({
    Key? key,
    required this.title,
    required this.takenImage,
  }) : super(key: key);
  final String title;
  final ImageModel takenImage;
  @override
  State<CamPage> createState() => _CamPageState();
}

class _CamPageState extends State<CamPage> {
  DateTime selectedDate = DateTime.now();
  String? selectedMealTime;
  File? image; //= takedimage as File?;
  String? path;
  XFile? newImage; //= takedimage ;
  String? filePath;
  bool saved = true;
  late String dateSelected = "";
  late String mealTime;
  bool mealTimeSelected = false;
  bool hasTimeError = false;

  final imageStorage storage = imageStorage();
  final ImagePicker picker = ImagePicker();

  late String imageUrlFromFireStore;

  // for save the image
  Future<void> saveImages(ImageModel takenImage) async {

    print("++++++++++" + selectedMealTime.toString());
    if(selectedMealTime==null){
      Fluttertoast.showToast(
        msg: "Please select meal time",
      );
    }
    if (selectedMealTime != null) {
      Fluttertoast.showToast(
        msg: "Please wait",
      );
      final now = DateTime.now(); // date and time of the moment
      // print(takenImage.path);
      // String filepath =
      //     '$filePath/' + now.toString() + '.png'; // make now as image name
      // final File newImage = await File(takenImage.path!)
      //     .copy('$filePath/' + now.toString() + '.png');
      imageUrlFromFireStore =
          await storage.uploadFile(takenImage.path!, now.toString() + ".png");

     // String fileName = now.toString() + '.' + takenImage.name!.split(".").last;
      // imageUrlFromFireStore = await storage.uploadData(
      //     takenImage.bytes!, 'images/${user!.email}/$fileName');
      print(imageUrlFromFireStore);

      await storage
          .setImageUrl(selectedDate.toString().split(' ')[0], selectedMealTime!,
              imageUrlFromFireStore)
          .then(
            (value) => Fluttertoast.showToast(
              msg: "The image saved",
            ),
          );

      setState(() {
        /*image = (newImage as XFile?)!;*/
      });
    } else {
      Fluttertoast.showToast(
        msg: "Please select meal time",
      );
    }
  }

  void stateReload() {
    print("==============================");
    print("State reload");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        child: const Icon(Icons.save),
        backgroundColor: ThemeInfo.primaryColor,
        onPressed: () {
          if (selectedMealTime != null) {
            if (saved) {
              saveImages(widget.takenImage); // working
              saved = false;
            }
          } else {
            setState(() {
              hasTimeError = true;
            });
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
                children: [
                  Text(
                    "Date_and_time:".tr,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ]),
            const SizedBox(
              height: 20,
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
                setState(() {});
              },
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
              child: DropdownButtonFormField(
                value: selectedMealTime,
                style: TextStyle(
                    color: ThemeInfo.dropDownValueColor, fontSize: 18),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: mealTimes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? val) {
                  selectedMealTime = val;
                  result = null;
                  setState(() {});
                },
                hint: Text(mealTimeDropdownHint),
              ),
            ),
            if (hasTimeError)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  mealTimeDropdownErrorMessage,
                  style:
                      TextStyle(color: ThemeInfo.errorTextColor, fontSize: 12),
                ),
              ),
            /*FormField<String>(
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
                          mealTimeSelected = true;
                          selectedMealTime = newValue;
                          mealTime = newValue!;
                          print(selectedMealTime);
                          // getFoodData(selectedMeal!);
                          state.didChange(newValue);
                          stateReload();
                          Fluttertoast.showToast(
                            msg: mealTime,
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
            ),*/
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 500, child: Image.memory(widget.takenImage.bytes!)),
            //Image.file(new_IMAGE as File),
            // image != null
            //     ? Image.file(takenImage as File) //(image!)
            //     : const Center(
            //         heightFactor: 2.2,
            //         child: Icon(
            //           Icons.food_bank,
            //           size: 180,
            //           color: Color.fromARGB(100, 125, 156, 139),
            //         ),
            //       ),
          ],
          //   ),
          //   //child: raw(),
          // ),
        ),
      ),
    );
  }
}
