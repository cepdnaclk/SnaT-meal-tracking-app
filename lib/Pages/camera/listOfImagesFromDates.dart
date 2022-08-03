import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
//import 'package:photo_view/photo_view.dart';
//import 'package:photo_view/photo_view_gallery.dart';
import '../../Services/IamageStoreService.dart';
import '../../Theme/theme_info.dart';
import 'camera_tabview.dart';
import 'list_of_images.dart';
import 'oneImageViewFromGrid.dart';
import 'one_image_view_page.dart';

class ScrollViewlistAccordingToDates extends StatelessWidget {
  final imageStorage staorage = imageStorage();
  var image_path = <String>[]; // Creates growable list.
  List <String> dates=[];
  List <String>imageList =[];
  List<String> mealTimes = [];

  ScrollViewlistAccordingToDates(List <String> dates , List<String> mealTimes) {
    this.dates = dates;
    this.mealTimes = mealTimes;
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Meal Gallery'; // main Title
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
          appBar:AppBar(
            title: Text("Image_List".tr),
            actions: [
              IconButton(
                icon: const Icon(Icons.line_weight_sharp),
                tooltip: 'list Icon',
                onPressed: () async {
                  // String urlDelete = await staorage.deletefromfirebase(date,mealtime,imageurl);
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (contex) { //return CameraScreen(widget.cameras);
                  //       return listAccordingToDate(date, mealtime,urlDelete);
                  //     })
                  // );
                  //staorage.delete(imageurl);

                },
              ),
              IconButton(
                icon: const Icon(Icons.grid_view),
                tooltip: 'grid Icon',
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                          builder: (contex) { //return CameraScreen(widget.cameras);
                            return gridview(dates,mealTimes);
                          })
                      );
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
                  CircularProgressIndicator(backgroundColor: Colors.greenAccent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                );
              } else {
                if (snapshot.hasError) {
                  // for errors
                  return Text(snapshot.error.toString());
                } else {
                  return GridView.builder(
                    gridDelegate: // grid view
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return
                        Card(
                            child: InkWell(
                              onTap: () {// view individual image
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
          )
      ),
    );
  }
}

// class ScrollViewlistAccordingToDates extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _ScrollViewlist();
//   }
// }

// class _ScrollViewlist extends State<ScrollViewlistAccordingToDates> {
//   //var files;
//   final imageStorage staorage = imageStorage();
//   var image_path = <String>[]; // Creates growable list.
//
//   @override
//   void initState() {
//     print("====================================================================\n");
//     print("dsds\n");
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const title = 'Meal Gallery'; // main Title
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: title,
//       home: Scaffold(
//           appBar: null,
//           body: FutureBuilder(
//             future: staorage.loadImages(),
//             //getpaths(),
//             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 // untill the data is load
//                 return const Center(
//                   //child: Text('Waiting'),
//                   child:
//                   CircularProgressIndicator(backgroundColor: Colors.red,
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
//                       crossAxisCount: 1,
//                       mainAxisSpacing: 10,
//                     ),
//                     itemCount: snapshot.data.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return
//                         Card(
//                             child: InkWell(
//                               onTap: () {// view individual image
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (contex)
//                                     {
//                                       return oneimageviewfromgrid(snapshot.data[index]);
//                                     })
//                                 );
//                               },
//                               onLongPress: () {},
//                               child: Image.network(
//                                 snapshot.data[index],
//                               ),
//                             )
//                         );
//                     },
//                   );
//                 }
//               }
//             },
//           )
//       ),
//     );
//   }
// }
