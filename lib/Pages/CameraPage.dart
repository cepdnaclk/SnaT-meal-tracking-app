// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';



import '../Theme/theme_info.dart';
import 'list_of_images.dart';



class campage extends StatefulWidget {
  const campage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<campage> createState() => _campageState();
}

class _campageState extends State<campage> {

  File? image;
  late String path;
  static int imagenumber=0;
  XFile? new_IMAGE;
  late String filePath;
  bool saved= true;
  // method for pick image from Gallery
  Future pickImage() async {
    try {

      var image = await ImagePicker().pickImage(source: ImageSource.gallery,maxHeight: 470,maxWidth: 470,imageQuality: 100,preferredCameraDevice: CameraDevice.rear);
      new_IMAGE=image;
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
      var image = await ImagePicker().pickImage(source: ImageSource.camera,maxHeight: 470,maxWidth: 470,imageQuality: 100,preferredCameraDevice: CameraDevice.rear);
      new_IMAGE=image;

      final Directory? extDir = await getExternalStorageDirectory();
      final String dirPath = extDir!.path.toString();
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/';// path for image

      //print("       -------        -----------            ------------ "+filePath);///storage/emulated/0/Android/data/com.example.mobile_app/files/
      //final now = DateTime.now();
      //final File newImage = await File(image!.path).copy('$filePath/'+now.toString()+'.png');
      //imagenumber++;



      if(image == null) return;
      //print("path:-----------------------------------------------"+image.path);
      //path=image.path;
      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);

      await GallerySaver.saveImage(image.path);

      // setState(() {
      //   image = newImage as XFile?;
      // });

    }
    on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
  // ffor save the image
  Future<void> saveimages(String filePath,XFile image) async{
    final now = DateTime.now();
    final File newImage = await File(image.path).copy('$filePath/'+now.toString()+'.png');
    if(image == null) return;
    setState(() {
      image = (newImage as XFile?)!;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Picker Example"),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "btn1",
          child: const Icon(Icons.save),
          backgroundColor: ThemeInfo.primaryColor,
          onPressed: (){
          if(saved) {
          saveimages(filePath, new_IMAGE!); // working
          saved=false;
        }
          },
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(// Gallery
                  color: Colors.blue,
                  child: const Text(
                      "Pick Image from Gallery",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: () {
                    saved=true;
                    pickImage();
                  }
              ),
              MaterialButton( // for camera
                  color: Colors.blue,
                  child: const Text(
                      "Pick Image from Camera",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: () {
                   saved=true;

                pickImageC();
                  }
              ),
              SizedBox(height: 20,),
              image != null ? Image.file(image!): Icon(Icons.restaurant_menu,size: 390,color:Color.fromARGB(100, 125, 156, 139) ,),
              //Text("No image selected"),

              MaterialButton(// for meal Gallery
                  color: Colors.blue,
                  child: const Text(
                      "Meal Diary",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (contex)
                        {//return CameraScreen(widget.cameras);
                          return MyFileList();
                          //return list_images();
                        })
                    );

                  },
                    //DisplayPictureScreen(imagePath: '/storage/emulated/0/Android/data/com.example.mobile_app/files/',);
              ),
              // MaterialButton( // for saved the images in the meal gallery
              //   color: Colors.blue,
              //   child: const Text(
              //       "Save",
              //       style: TextStyle(
              //           color: Colors.white70, fontWeight: FontWeight.bold
              //       )
              //   ),
              //   onPressed: (){
              //     if(saved) {
              //       saveimages(filePath, new_IMAGE!); // working
              //       saved=false;
              //     }
              //   },
              //   //DisplayPictureScreen(imagePath: '/storage/emulated/0/Android/data/com.example.mobile_app/files/',);
              // ),
              // SizedBox(height: 20,),
              // image != null ? Image.file(image!): Text("No image selected")

            ],

          ),

        ),
    //     floatingActionButton: FloatingActionButton(
    //     child: const Icon(Icons.camera_alt_outlined),
    // backgroundColor: ThemeInfo.primaryColor,
    // onPressed: (){
    // Navigator.of(context).push(MaterialPageRoute(
    // builder: (contex)
    // {//return CameraScreen(widget.cameras);
    // return const DisplayPictureScreen(imagePath: path,);
    // }
    // )
    //
    // );
    // },
    // ),
    );
  }
  // saveScreen() async {
  //   RenderRepaintBoundary boundary = gobalkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //   ui.Image image = await boundary.toImage();
  //   ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png) as FutureOr<ByteData?>);
  //   if (byteData != null) {
  //     final result =
  //     await image_gallery_saver.saveImage(byteData.buffer.asUint8List());
  //     print(result);
  //    // _toastInfo(result.toString());
  //   }
  // }
}


