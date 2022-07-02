import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../Components/date_time_widget.dart';
import '../../Services/DateTime.dart';
import '../../Services/IamageStoreService.dart';
import '../../Theme/theme_info.dart';
import '../add_a_meal_screen.dart';

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
  bool saved= true;
  late String MealTime ;
  final imageStorage staorage = imageStorage();
  final ImagePicker picker = ImagePicker();

  late String imageuflFromFireStore;

  Future pickImage() async {
    try {
      var image = await picker.pickImage(source: ImageSource.gallery,maxHeight: 400,maxWidth: 400,preferredCameraDevice: CameraDevice.rear);
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
  // for save the image
  Future<void> saveimages(String filePath,XFile image) async{
    final now = DateTime.now();// date and time of the moment
    String filepath = '$filePath/'+now.toString()+'.png';// make now as image name
    final File newImage = await File(image.path).copy('$filePath/'+now.toString()+'.png');
    imageuflFromFireStore = await staorage.uploadFile(filepath, now.toString()+".png");
    print(imageuflFromFireStore);
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
      appBar: AppBar(
        title: const Text("new meal Image"),

      ),
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
                  print(val);
                  setState(() {});
                },
              ),
              MaterialButton(// Gallery
                  elevation: 100,
                  hoverElevation: 100,
                  focusElevation: 50,
                  highlightElevation: 50,
                  color: Colors.black12,
                  child: const Text(
                      "Pick from Gallery",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold , fontSize: 15,
                      )
                  ),
                  onPressed: () {
                    saved=true;
                    pickImage();
                  }
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
                            selectedMealTime = newValue!;
                            MealTime = newValue;
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
