/*
this is for choose date and meal time and save the images in fire base
user have to choose date amd meal time
and relevent image
then hae to save

 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../Components/date_time_widget.dart';
import '../../Services/DateTime.dart';
import '../../Services/IamageStoreService.dart';
import '../../Theme/theme_info.dart';
import '../../constants.dart';
import '../add_a_meal_screen.dart';
//delete----------------------------------------------------------------------------------------------------------------
class mealIamgeAnotherDay extends StatefulWidget {
  const mealIamgeAnotherDay({Key? key}) : super(key: key);

  @override
  _mealIamgeAnotherDayState createState() => _mealIamgeAnotherDayState();
}

class _mealIamgeAnotherDayState extends State<mealIamgeAnotherDay> {
  DateTime selectedDate = DateTime.now();
  File? image;
  String? path;
  XFile? new_IMAGE;
  String? filePath;
  bool saved = true;
  late String MealTime = "Others";
  late String dateSelected = "";
  final imageStorage staorage = imageStorage();
  final ImagePicker picker = ImagePicker();
  bool mealtimeselected = false;

  late String imageurlFromFireStore;
  // method for pick images from gallery
  // method for pick image from Gallery
  Future pickImage() async {
    try {
      var image = await picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 400,
          maxWidth: 400,
          imageQuality: 80,
          preferredCameraDevice: CameraDevice.rear);
      new_IMAGE = image as XFile;
      // var path2 = image!.path;
      print("===============================");
      // giving access to save only .jpg and pgg format
      String filename = basename(image.path);
      print(filename);
      String jpg = ".jpg";
      String png = ".png";
      if (!(filename.contains(jpg) | filename.contains(png))) {
        image = null;
        saved = false;
        Fluttertoast.showToast(
          msg: "Please use only .jpg and .png format",
        );
      }
      final Directory? extDir = await getExternalStorageDirectory();
      final String dirPath = extDir!.path.toString();
      await Directory(dirPath).create(recursive: true);
      filePath = '$dirPath/'; // taking image  path
      if (image == null) return;
      final imageTemp = File(image.path);
      await GallerySaver.saveImage(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  // for save the image
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
              msg: "The image saved",
            ),
          );

      if (image == null) return;
      setState(() {
        image = (newImage as XFile?)!;
      });
    } else {
      Fluttertoast.showToast(
        msg: "Please select a meal time",
      );
    }
  }

  void StateReload() {
    print("State reload");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Date & Mealtime"),
        // titleSpacing: 00.0,
        // centerTitle: true,
        // toolbarHeight: 60.2,
        // toolbarOpacity: 0.8,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //       bottomRight: Radius.circular(25),
        //       bottomLeft: Radius.circular(25)),
        // ),
        // elevation: 0.00,
        backgroundColor: ThemeInfo.primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  setState(() {});
                },
              ),
              MaterialButton(
                  // Gallery
                  elevation: 100,
                  hoverElevation: 100,
                  focusElevation: 50,
                  highlightElevation: 50,
                  color: Colors.black12,
                  child: const Text("Pick from Gallery",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                  onPressed: () {
                    saved = true;
                    pickImage();
                  }),
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
                            print("+++++++=============++++++=== setstate");
                            mealtimeselected = true;
                            selectedMealTime = newValue!;
                            MealTime = newValue;
                            print(selectedMealTime);
                            // getFoodData(selectedMeal!);
                            state.didChange(newValue);
                            StateReload();
                            Fluttertoast.showToast(
                              msg: MealTime,
                            );
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
              const SizedBox(
                height: 5,
              ),
              image != null
                  ? Image.file(image!) :
              const Center(
                heightFactor:2.2,
                child: Icon(
                  Icons.food_bank,
                  size: 180,
                  color: Color.fromARGB(100, 125, 156, 139),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
