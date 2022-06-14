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
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:fluttertoast/fluttertoast.dart';

//import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'list_of_images.dart';

//import 'package:permission_handler/permission_handler.dart';


class campage extends StatefulWidget {
  const campage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<campage> createState() => _campageState();
}

class _campageState extends State<campage> {

  File? image;
  late String path;
  static int imagenumber=0;

  Future pickImage() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery,maxHeight: 470,maxWidth: 470,imageQuality: 100,preferredCameraDevice: CameraDevice.rear);
      // var path2 = image!.path;
      final Directory? extDir = await getExternalStorageDirectory();
      final String dirPath = extDir!.path.toString();
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/';
      print("       -------        -----------            ------------ "+filePath);///storage/emulated/0/Android/data/com.example.mobile_app/files/

      // getting a directory path for saving
      //final String path1 = await getApplicationDocumentsDirectory()!.path.toString().;
      //
      // // copy the file to a new path
       final File newImage = await File(image!.path).copy('$filePath/gallery'+imagenumber.toString()+'.png');
       imagenumber++;


      if(image == null) return;
      print("path:-----------------------------------------------"+image.path);
      //path=image.path;
      final imageTemp = File(image.path);

      await GallerySaver.saveImage(image.path);

      setState(() => this.image = imageTemp);

      setState(() {
        image = newImage as XFile?;
      });



    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.camera,maxHeight: 470,maxWidth: 470,imageQuality: 100,preferredCameraDevice: CameraDevice.rear);


      final Directory? extDir = await getExternalStorageDirectory();
      final String dirPath = extDir!.path.toString();
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/';
      print("       -------        -----------            ------------ "+filePath);///storage/emulated/0/Android/data/com.example.mobile_app/files/

      final File newImage = await File(image!.path).copy('$filePath/camera'+imagenumber.toString()+'.png');
      imagenumber++;



      if(image == null) return;
      print("path:-----------------------------------------------"+image.path);
      path=image.path;
      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);

      await GallerySaver.saveImage(image.path);
      setState(() {
        image = newImage as XFile?;
      });

    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Picker Example"),
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                  color: Colors.blue,
                  child: const Text(
                      "Pick Image from Gallery",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: () {
                    pickImage();
                  }
              ),
              MaterialButton(
                  color: Colors.blue,
                  child: const Text(
                      "Pick Image from Camera",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: () {
                    pickImageC();
                  }
              ),
              // MaterialButton(
              //     color: Colors.blue,
              //     child: const Text(
              //         "Gallery",
              //         style: TextStyle(
              //             color: Colors.white70, fontWeight: FontWeight.bold
              //         )
              //     ),
              //     onPressed: (){
              //           Navigator.of(context).push(MaterialPageRoute(
              //           builder: (contex)
              //             {//return CameraScreen(widget.cameras);
              //               return (){};
              //             })
              //           );
              //     },
              //       //DisplayPictureScreen(imagePath: '/storage/emulated/0/Android/data/com.example.mobile_app/files/',);
              //
              // ),
              SizedBox(height: 20,),
              image != null ? Image.file(image!): Text("No image selected")

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



// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
// await Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => DisplayPictureScreen(
//                   // Pass the automatically generated path to
//                   // the DisplayPictureScreen widget.
//                   imagePath: image.path,
//                 ),
//               ),
//             );








//
// class CameraScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;
//
//   CameraScreen(this.cameras);
//
//   @override
//   CameraScreenState createState() {
//     return new CameraScreenState();
//   }
// }
//
// class CameraScreenState extends State<CameraScreen> {
//   late CameraController controller;
//   late Future<void> _initializeControllerFuture;
//   String iPath = "";
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     controller =
//     new CameraController(widget.cameras[1], ResolutionPreset.medium);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//     // Next, initialize the controller. This returns a Future.
//     _initializeControllerFuture = controller.initialize();
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   if (!controller.value.isInitialized) {
//   //     return new Container();
//   //   }
//   //   return new AspectRatio(
//   //     aspectRatio: controller.value.aspectRatio,
//   //     child: new CameraPreview(controller),
//   //   );
//   // }
//
//
//
//

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //appBar: AppBar(title: const Text('Take a picture')),
//       // You must wait until the controller is initialized before displaying the
//       // camera preview. Use a FutureBuilder to display a loading spinner until the
//       // controller has finished initializing.
//       body:
//       FutureBuilder<void>(
//
//         future: _initializeControllerFuture,
//
//         builder: (context, snapshot) {
//           //child: Center(
//           if (snapshot.connectionState == ConnectionState.done) {
//             // If the Future is complete, display the preview.
//             return CameraPreview(controller,child:
//                 Text("Chiran"),
//
//
//             );
//           } else {
//             // Otherwise, display a loading indicator.
//             return const Center(child: CircularProgressIndicator(backgroundColor: Color.fromARGB(20, 20, 20, 20),strokeWidth: 18,)
//
//             );
//           }
//        //   );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         // Provide an onPressed callback.
//         onPressed: () async {
//           // Take the Picture in a try / catch block. If anything goes wrong,
//           // catch the error.
//           try {
//             print("--------------------------------------------------------------------------floating works");
//             // Ensure that the camera is initialized.
//             await _initializeControllerFuture;
//
//             // Attempt to take a picture and get the file `image`
//             // where it was saved.
//             final image = await controller.takePicture();
//             iPath=image.path;
//
//             // If the picture was taken, display it on a new screen.
//             await Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => DisplayPictureScreen(
//                   // Pass the automatically generated path to
//                   // the DisplayPictureScreen widget.
//                   imagePath: image.path,
//                 ),
//               ),
//             );
//             print("     ---------------------------------------------------"+iPath);
//           } catch (e) {
//             // If an error occurs, log the error to the console.
//             print("///////---------------------------------------------------"+iPath);
//             //print(e);
//           }
//         },
//         child: const Icon(Icons.camera_alt),
//       ),
//     );
//   }
// }
//
//





//---------------------------------------------------------------------------------------------






// class CameraPage extends StatelessWidget {
//   const CameraPage({Key? key}) : super(key: key);
//
//
//   // Ensure that plugin services are initialized so that `availableCameras()`
// // can be called before `runApp()`
//   //WidgetsFlutterBinding.ensureInitialized();
//
// // Obtain a list of the available cameras on the device.
//   //final cameras = await availableCameras();
//
// // Get a specific camera from the list of available cameras.
//   //final firstCamera = cameras.first;
//
//   @override
//   Widget build(BuildContext context) {
//     return TakePictureScreen();
//
//   }
// }
// class CameraPage extends StatefulWidget {
//   const CameraPage({Key? key, required this.camera}) : super(key: key);
//   final CameraDescription camera;
//
//   @override
//   _CameraPageState createState() => _CameraPageState();
// }
//
// class _CameraPageState extends State<CameraPage> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   @override
//   void initState() {
//     super.initState();
//     // To display the current output from the Camera,
//     // create a CameraController.
//     _controller = CameraController(
//       // Get a specific camera from the list of available cameras.
//       widget.camera,
//       // Define the resolution to use.
//       ResolutionPreset.medium,
//     );
//         // Next, initialize the controller. This returns a Future.
//     _initializeControllerFuture = _controller.initialize();
//   }
//
//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _controller.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }


//
// class TakePictureScreen extends StatefulWidget {
//   const TakePictureScreen({,required this.camera,});
//
//   final CameraDescription camera;
//
//   @override
//   TakePictureScreenState createState() => TakePictureScreenState();
// }
//
// class TakePictureScreenState extends State<TakePictureScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     // To display the current output from the Camera,
//     // create a CameraController.
//     _controller = CameraController(
//       // Get a specific camera from the list of available cameras.
//       widget.camera,
//       // Define the resolution to use.
//       ResolutionPreset.medium,
//     );
//
//     // Next, initialize the controller. This returns a Future.
//     _initializeControllerFuture = _controller.initialize();
//   }
//
//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Fill this out in the next steps.
//     return Container();
//   }
// }
//
//
//
