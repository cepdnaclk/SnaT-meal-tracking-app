/*
  show individual images the image url is requied for this
 */
import 'package:flutter/material.dart';
import '../../Services/IamageStoreService.dart';
import '../../Theme/theme_info.dart';
import '../add_a_meal_screen.dart';
import 'camera_tabview.dart';
import 'listOfImagesAccordingToDate.dart';
import 'list_of_images.dart';

class showimage extends StatelessWidget {
  var imageurl;
  String date;
  String mealtime;
  final imageStorage staorage = imageStorage();
  late String docid;
  showimage(this.imageurl,this.date,this.mealtime) {
    print(imageurl);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'EasyFlutter',
      home: Scaffold(
        appBar:AppBar(
          title: Text(date +' '+mealtime),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete Icon',
              onPressed: () async {
                String urlDelete = await staorage.deletefromfirebase(date,mealtime,imageurl);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (contex) { //return CameraScreen(widget.cameras);
                      return listAccordingToDate(date, mealtime,urlDelete);
                    })
                );
                //staorage.delete(imageurl);

              },
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'back',
            onPressed: () {Navigator.of(context).push(MaterialPageRoute(
                builder: (contex)
                {//return CameraScreen(widget.cameras);
                  return listAccordingToDate(date,mealtime,"");
                })
            );
            },
          ),
          titleSpacing: 00.0,
          centerTitle: true,
          toolbarHeight: 60.2,
          toolbarOpacity: 0.8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)),
          ),
          elevation: 0.00,
          backgroundColor: ThemeInfo.primaryColor,
        ),
        body: Center(
          child: Image.network(
            imageurl,
            height: 400,
            width: 400,
          ),
        ),
      ),
    );
  }
}



