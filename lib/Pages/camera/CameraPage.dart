
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/Services/IamageStoreService.dart';
import 'package:path_provider/path_provider.dart';


import '../../Theme/theme_info.dart';
import '../add_a_meal_screen.dart';



class campage extends StatefulWidget {
  const campage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<campage> createState() => _campageState();
}

class _campageState extends State<campage> {
  DateTime selectedDate = DateTime.now();
  File? image;
  String? path;
  XFile? new_IMAGE;
  String? filePath;
  bool saved= true;
  late String MealTime ="Others";

  final imageStorage staorage = imageStorage();
  final ImagePicker picker = ImagePicker();

  late String imageurlFromFireStore;
  // method for pick image from Gallery
  Future pickImage() async {
    try {
      var image = await picker.pickImage(source: ImageSource.gallery,maxHeight: 400,maxWidth: 400,imageQuality: 80,preferredCameraDevice: CameraDevice.rear);
      new_IMAGE=image ;
      // var path2 = image!.path;
      final Directory? extDir = await getExternalStorageDirectory();
      final String dirPath = extDir!.path.toString();
      await Directory(dirPath).create(recursive: true);
      filePath = '$dirPath/'; // taking image  path
      if(image == null) return;
      final imageTemp = File(image.path);
      await GallerySaver.saveImage(image.path);
      setState(() => this.image = imageTemp);
    }
    on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
  // pick Image from camera
  Future pickImageC() async {
    try {
      var image = await picker.pickImage(source: ImageSource.camera,maxHeight: 470,maxWidth: 470,imageQuality: 80,preferredCameraDevice: CameraDevice.rear);
      new_IMAGE=image ;
      final Directory? extDir = await getExternalStorageDirectory();
      final String dirPath = extDir!.path.toString();
      await Directory(dirPath).create(recursive: true);
      filePath = '$dirPath/';// path for image
      if(image == null) return;
      final imageTemp = File(image.path);
      await GallerySaver.saveImage(image.path);
      setState(() => this.image = imageTemp);
    }
    on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
  // for save the image
  Future<void> saveimages(String filePath,XFile image) async{
    final now = DateTime.now();// date and time of the moment
    String filepath = '$filePath/'+now.toString()+'.png';// make now as image name
    final File newImage = await File(image.path).copy('$filePath/'+now.toString()+'.png');
    imageurlFromFireStore = await staorage.uploadFile(filepath, now.toString()+".png");
    print(imageurlFromFireStore);

    await staorage.setImageUrl(selectedDate.toString().split(' ')[0], MealTime, imageurlFromFireStore);

    if(image == null) return;
    setState(() {
      image = (newImage as XFile?)!;
    });
  }
  void StateReload() {
    print("State reload");
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        floatingActionButton: FloatingActionButton(
          heroTag: "btn1",
          child: const Icon(Icons.save),
          backgroundColor: ThemeInfo.primaryColor,
          onPressed: (){
          if(saved) {
            if(new_IMAGE!=null){ saveimages(filePath!, new_IMAGE!); // working
            saved=false;
            }
        }
          },
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(// Gallery
                        elevation: 0,
                        hoverElevation: 0,
                        focusElevation: 0,
                        highlightElevation: 0,
                        textColor: Colors.black,
                        //color: Colors.white,
                        child: const Text(
                            "Pick from Gallery",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold , fontSize: 15 ,
                            )
                        ),
                        onPressed: () {
                          saved=true;
                          pickImage();
                        }
                    ),
                    MaterialButton( // for camera
                        elevation: 0,
                        hoverElevation: 0,
                        focusElevation: 0,
                        highlightElevation: 0,
                        textColor: Colors.black,
                        child: const Text(
                            "Pick from Camera",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold , fontSize: 15 ,
                            )
                        ),
                        onPressed: () {
                          saved=true;
                          pickImageC();
                        }
                    ),
                ]
              ),
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
                            selectedMealTime = newValue;
                            MealTime = newValue!;
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
              const SizedBox(height: 2,),
              image != null ? Image.file(image!): const Icon(Icons.food_bank,size: 380,color:Color.fromARGB(100, 125, 156, 139) ,),
            ],
          ),
        ),
    );
  }

}


