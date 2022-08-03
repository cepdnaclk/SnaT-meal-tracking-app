/*
 ALL ABOUT THE MEAL GALLERY
 */
// importing packeges
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../Services/IamageStoreService.dart';
import '../../Theme/theme_info.dart';
import 'CameraPage.dart';
import 'camera_tabview.dart';
import 'listOfImagesFromDates.dart';
import 'oneImageViewFromGrid.dart';
import 'one_image_view_page.dart';
class gridview extends StatelessWidget {

  final imageStorage staorage = imageStorage();
  var image_path = <String>[]; // Creates growable list.
  List <String> dates=[];
  List <String>imageList =[];
  List<String> mealTimes = [];

  gridview(List <String> dates , List<String> mealTimes) {
    this.dates = dates;
    this.mealTimes = mealTimes;
  }

  @override
  Widget build(BuildContext context) {
    //const title = 'Meal Gallery'; // main Title

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: title,
      home: Scaffold(
          appBar:AppBar(
            title: Text("Image_List".tr),
            actions: [
              IconButton(
                icon: const Icon(Icons.line_weight_sharp),
                tooltip: 'list Icon',
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (contex) { //return CameraScreen(widget.cameras);
                        return ScrollViewlistAccordingToDates(dates,mealTimes);
                      })
                  );

                },
              ),
              IconButton(
                icon: const Icon(Icons.grid_view),
                tooltip: 'grid Icon',
                onPressed: () async {

                },
              ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'back',
              onPressed: () {Navigator.of(context).push(MaterialPageRoute(
                  builder: (contex)
                  {//return CameraScreen(widget.cameras);
                    return const tabviewcamera();
                  })
              );
              },
            ),

            elevation: 0.00,
            backgroundColor: ThemeInfo.primaryColor,
          ),
          body: FutureBuilder(
            future: staorage.allImagesListofADate(dates,mealTimes),
            //getpaths(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // untill the data is load
                return const Center(
                  //child: Text('Waiting'),
                  child:
                  CircularProgressIndicator(backgroundColor: Colors.limeAccent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),),
                );
              } else {
                if (snapshot.hasError) {
                  // for errors
                  return Text(snapshot.error.toString());
                } else {
                  return GridView.builder(
                    gridDelegate: // grid view
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return
                        Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (contex)
                                    {
                                      return showimage(snapshot.data[index],dates,mealTimes);
                                    })
                                );
                              },
                              onLongPress: () {},
                              child: Image.network(
                                snapshot.data[index],
                              ),
                            )

                        );

                    },
                  );
                }
              }
            },
          )),
    );
  }
}

// class MyFileList extends StatefulWidget {
//   const MyFileList({Key? key}) : super(key: key);
//   @override
//   State<StatefulWidget> createState() {
//     return _MyFileList();
//   }
// }
//
// class _MyFileList extends State<MyFileList> {
//   //var files;
//   final imageStorage staorage = imageStorage();
//   var image_path = <String>[]; // Creates growable list.
//
//   @override
//   void initState() {
//     print("====================================================================\n");
//     print("dsds\n");
//     staorage.deleteAfterExpire();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //const title = 'Meal Gallery'; // main Title
//
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       //title: title,
//       home: Scaffold(
//           appBar: null,
//
//           body: FutureBuilder(
//             future: staorage.loadImages(),
//             //getpaths(),
//             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 // untill the data is load
//                 return const Center(
//                   //child: Text('Waiting'),
//                   child:
//                   CircularProgressIndicator(backgroundColor: Colors.limeAccent,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.green),),
//                 );
//               } else {
//                 if (snapshot.hasError) {
//                   // for errors
//                   return Text(snapshot.error.toString());
//                 } else {
//                   return GridView.builder(
//                     gridDelegate: // grid view
//                     const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 20,
//                     ),
//                     itemCount: snapshot.data.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return
//                         Card(
//                           child: InkWell(
//                               onTap: () {
//                                 // Navigator.of(context).push(MaterialPageRoute(
//                                 //     builder: (contex)
//                                 //     {
//                                 //       return oneimageviewfromgrid(snapshot.data[index]);
//                                 //     })
//                                 // );
//                               },
//                               onLongPress: () {},
//                               child: Image.network(
//                                   snapshot.data[index],
//                               ),
//                           )
//
//                         );
//
//                     },
//                   );
//                 }
//               }
//             },
//           )),
//     );
//   }
// }
