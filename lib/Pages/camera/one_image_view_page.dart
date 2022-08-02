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
  late String date;
  late String mealtime;
  final imageStorage staorage = imageStorage();
  late String docid;
  List <String> datelist;
  List <String> mealtimes;
  late List <String> details;

  showimage(this.imageurl,this.datelist,this.mealtimes, {Key? key}) : super(key: key) {
    print("showimage");
    print(imageurl);
    mealtimeAndDate();

  }
  Future<void> mealtimeAndDate() async{
     details = await staorage.takeMealTimeAndDateFromUrl(imageurl, datelist) ;
     date = details[0];
     mealtime = details[1];
     print(date+"  "+mealtime);

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'EasyFlutter',
      home: Scaffold(
        appBar:AppBar(
          title: Text("A MEAL"),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete Icon',
              onPressed: () async {
                String urlDelete = await staorage.deletefromfirebase(date,mealtime,imageurl);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (contex) { //return CameraScreen(widget.cameras);
                      return gridview(datelist, mealtimes);
                    })
                );
                //staorage.delete(imageurl);

              },
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'back',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (contex)
                {//return CameraScreen(widget.cameras);
                  return gridview(datelist, mealtimes);
                })
            );
            },
          ),
          elevation: 0.00,
          backgroundColor: ThemeInfo.primaryColor,
        ),


          body: FutureBuilder(
            future:mealtimeAndDate(),
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
                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Image.network(
                                  imageurl,
                                  height: 400,
                                  width: 400,
                                ),
                      const SizedBox(
                        height: 20,
                      ),
                        Text(details[0]),
                      const SizedBox(
                        height: 20,
                      ),
                          Text(details[1])

                  ]
                  );
                }
              }
            },
          )
      ),
    );
  }
}



