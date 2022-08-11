import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/Models/image_model.dart';
import 'package:mobile_app/Services/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';

List<ImageModel> galleryImages = [];

class CameraTest extends StatefulWidget {
  const CameraTest({Key? key, required this.resultCallback}) : super(key: key);
  final Function resultCallback;

  @override
  _CameraTestState createState() => _CameraTestState();
}

class _CameraTestState extends State<CameraTest> {
  late CameraController controller;
  bool showGallery = false;
  double screenHeight = 0;
  double screenWidth = 0;
  double circleAvatarRadius = 35;
  bool showImageToSave = false;
  late ImageModel capturedImage;
  late XFile image;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError(
      (Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              print('User denied camera access.');
              break;
            default:
              print('Handle other errors.');
              break;
          }
        }
      },
    );
    loadImages();
  }
  loadImages() async {
    PermissionStatus status =
    await PermissionManager.checkPermissionForCamera();
    if (status == PermissionStatus.granted) {
      Directory cameraDir = Directory("/storage/emulated/0/DCIM/Camera");
      Directory applicationDir = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> imageList = applicationDir.listSync();
      if (await cameraDir.exists()) imageList.addAll(cameraDir.listSync());
      galleryImages = [];
      for (FileSystemEntity image in imageList) {
        print(image);
        if (image.path.split('/').last.isImageFileName) {
          Uint8List galleryImage = await File(image.path).readAsBytes();
          ImageModel galleryImageModel = ImageModel(
              name: image.uri.pathSegments.last,
              bytes: galleryImage,
              path: image.path,
              size: galleryImage.length);
          galleryImages.add(galleryImageModel);
        }
      }
    } else {
      Directory applicationDir = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> imageList = applicationDir.listSync();

      for (FileSystemEntity image in imageList) {
        print(image);
        if (image.path.split('/').last.isImageFileName) {
          Uint8List galleryImage = await File(image.path).readAsBytes();
          ImageModel galleryImageModel = ImageModel(
              name: image.uri.pathSegments.last,
              bytes: galleryImage,
              path: image.path,
              size: galleryImage.length);
          galleryImages.add(galleryImageModel);
        }
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // change the value to increase sensitivity
  double minDragFactor = 0.4;

  double startingPos = 0;
  double endPos = 0;

  verticalDragUpdateHandler(DragUpdateDetails drag) {
    endPos = drag.globalPosition.dy;
  }

  verticalDragStartHandler(DragStartDetails drag) {
    startingPos = drag.globalPosition.dy;
  }

  verticalDragEndHandler(DragEndDetails drag) {
    double currentDragFactor = (startingPos - endPos) / screenHeight;
    print(startingPos);
    print(endPos);
    print(currentDragFactor);
    if (currentDragFactor > minDragFactor) {
      setState(() {
        showGallery = true;
      });
    }
  }

  saveImage(ImageModel imageModel) async {
    Directory dir = await getApplicationDocumentsDirectory();
    print(dir.path);
    DateTime time = DateTime.now();
    print(
        time.toIso8601String().substring(2, time.toIso8601String().length - 4));
    String fileName =
        "Img_${time.toIso8601String().substring(2, time.toIso8601String().length - 4).replaceAll("-", "").replaceAll(":", "").replaceAll("T", "").replaceAll(".", "")}." +
            imageModel.name!.split(".").last;
    String path = dir.path + "/" + fileName;
    File localImageFile = File(path);
    imageModel.path = path;
    imageModel.name = fileName;
    await localImageFile.writeAsBytes(imageModel.bytes!).catchError((e) {
      print(e);
    }).whenComplete(
      () => print("done"),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: GestureDetector(
        onVerticalDragUpdate: verticalDragUpdateHandler,
        onVerticalDragEnd: verticalDragEndHandler,
        onVerticalDragStart: verticalDragStartHandler,
        onTapDown: (TapDownDetails tap) async {
          controller.setFocusPoint(Offset(tap.globalPosition.dx / screenWidth,
              tap.globalPosition.dy / screenHeight));
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.greenAccent,
                child: CameraPreview(controller),
              ),
            ),
            Positioned(
              bottom: 10,
              left:
                  (MediaQuery.of(context).size.width / 2) - circleAvatarRadius,
              child: CaptureButton(
                onCaptured: () async {
                  print("capturing");
                  image = await controller.takePicture();
                  ImageModel imageModel = ImageModel();
                  imageModel.name = image.name;
                  imageModel.bytes = await image.readAsBytes();
                  imageModel.path = image.path;
                  imageModel.size = await image.length();
                  capturedImage = imageModel;
                  setState(() {
                    showImageToSave = true;
                  });
                },
              ),
            ),
            if (showGallery)
              GalleryWidget(
                closingCallback: () {
                  setState(() {
                    showGallery = false;
                  });
                },
                imageSelectionCallback: (ImageModel selectedImage) {
                  widget.resultCallback(selectedImage);
                },
              ),
            if (showImageToSave)
              Stack(
                children: [
                  Positioned.fill(
                    child: Image.memory(capturedImage.bytes!),
                  ),
                  Positioned(
                    bottom: 10,
                    //textDirection: TextDirection.ltr,
                    child: SizedBox(
                      width: screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                showImageToSave = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.teal),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                              child: const Center(
                                child: Text(
                                  "   Retake   ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              saveImage(capturedImage);
                              widget.resultCallback(capturedImage);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.teal,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                              child: const Center(
                                child: Text(
                                  "Save Image",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class GalleryWidget extends StatefulWidget {
  const GalleryWidget(
      {Key? key,
      required this.closingCallback,
      required this.imageSelectionCallback})
      : super(key: key);
  final Function closingCallback;
  final Function imageSelectionCallback;

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  ImageModel? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      widget.closingCallback();
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 50,
                    ),
                  ),
                ),
                if (selectedImage != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            widget.imageSelectionCallback(selectedImage);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Text(
                              "Select",
                              style: TextStyle(fontSize: 15),
                            ),
                          ))
                    ],
                  ),
              ],
            ),

            const Divider(
              thickness: 1,
              color: Colors.black54,
            ),
            // Add code for the image gallery.
            Expanded(
              child: GridView.count(
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                crossAxisCount: 3,
                children: [
                  for (ImageModel image in galleryImages)
                    GestureDetector(
                      onTap: () {
                        selectedImage = image;

                        setState(() {});
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.memory(
                              image.bytes!,
                              fit: BoxFit.fill,
                            ),
                          ),
                          if (selectedImage != null)
                            Positioned(
                                top: 5,
                                left: 5,
                                child: GestureDetector(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: selectedImage == image
                                          ? const Color(0xaa056ae7)
                                          : Colors.transparent,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: selectedImage == image
                                        ? const Icon(
                                            Icons.done,
                                            color: Colors.white,
                                          )
                                        : const SizedBox(),
                                  ),
                                ))
                        ],
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:mobile_app/Pages/camera/CameraPage.dart';
//
// import '../../main.dart';
//
// class CameraTest extends StatefulWidget {
//   // List<CameraDescription> cameras;
//   //  CameraTest(this.cameras);
//   const CameraTest({Key? key}) : super(key: key);
//
//   @override
//   _CameraTestState createState() => _CameraTestState();
// }
//
// class _CameraTestState extends State<CameraTest> {
//   late CameraController controller;
//   bool showGallery = false;
//   double screenHeight = 0;
//   double circleAvatarRadius = 45;
//   //List<CameraDescription>? cameras=[];
//   //_CameraTestState(this,cameras);
//   //late List<CameraDescription> cameras;
//   // Future <void> cams() async {
//   //    cameras =await availableCameras();
//   //    print("============================================");
//   //    print(cameras);
//   // }
//
//   @override
//   void initState() {
//     // cams();
//     super.initState();
//     controller = CameraController(cameras[0], ResolutionPreset.max);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             print('User denied camera access.');
//             break;
//           default:
//             print('Handle other errors.');
//             break;
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   // change the value to increase sensitivity
//   double minDragFactor = 0.4;
//
//   double startingPos = 0;
//   double endPos = 0;
//
//   verticalDragUpdateHandler(DragUpdateDetails drag) {
//     endPos = drag.globalPosition.dy;
//   }
//
//   verticalDragStartHandler(DragStartDetails drag) {
//     startingPos = drag.globalPosition.dy;
//   }
//
//   verticalDragEndHandler(DragEndDetails drag) {
//     double currentDragFactor = (startingPos - endPos) * 100 / screenHeight;
//     if (currentDragFactor > minDragFactor) {
//       setState(() {
//         showGallery = true;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     screenHeight = MediaQuery.of(context).size.height;
//     return Material(
//       child: GestureDetector(
//         onVerticalDragUpdate: verticalDragUpdateHandler,
//         onVerticalDragEnd: verticalDragEndHandler,
//         onVerticalDragStart: verticalDragStartHandler,
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Container(
//                 color: Colors.red,
//                 child: CameraPreview(controller),
//               ),
//             ),
//             Positioned(
//               bottom: 10,
//               left:
//                   (MediaQuery.of(context).size.width / 2) - circleAvatarRadius,
//               child: GestureDetector(
//                 onTap: () async {
//                   XFile image = await controller.takePicture();
//                   //print(await image.readAsBytes());
//                   Navigator.of(context).push(MaterialPageRoute(
//                       builder: (contex) { //return CameraScreen(widget.cameras);
//                         return campage(image,image.path ,"");
//                       })
//                   );
//                 },
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   radius: circleAvatarRadius,
//                 ),
//               ),
//             ),
//             if (showGallery)
//               Positioned.fill(
//                   child: SafeArea(
//                   child: Container(
//                   color: Colors.white,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               showGallery = true;
//                             });
//                           },
//                           child: const Icon(
//                             Icons.keyboard_arrow_down,
//                             size: 50,
//                           ),
//                         ),
//                       ),
//                       const Text(
//                         "Your Images",
//                         style: TextStyle(color: Colors.black, fontSize: 30),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       const Divider(
//                         thickness: 1,
//                         color: Colors.black54,
//                       ),
//                       // Add code for the image gallery.
//                       Expanded(
//                         child: GridView.count(
//                           crossAxisCount: 3,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ))
//           ],
//         ),
//       ),
//     );
//   }
// }

class CaptureButton extends StatefulWidget {
  const CaptureButton({
    Key? key,
    required this.onCaptured,
  }) : super(key: key);
  final Function onCaptured;

  @override
  State<CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton> {
  double elevation = 5;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(39),
          elevation: 10,
          child: Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
        ),
        Positioned(
          top: 5,
          left: 5,
          child: Material(
            elevation: elevation,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(34),
            child: GestureDetector(
              onTap: () {
                widget.onCaptured();
              },
              onTapDown: (val) {
                setState(() {
                  elevation = 0;
                });
              },
              onTapUp: (val) {
                late Timer timer1;
                timer1 =
                    Timer.periodic(const Duration(milliseconds: 100), (timer) {
                  timer1.cancel();
                  setState(() {
                    elevation = 5;
                  });
                });
              },
              child: CircleAvatar(
                backgroundColor:
                    elevation == 0 ? Colors.grey : const Color(0xffeceae6),
                radius: 34,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
