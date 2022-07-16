/*
  showing list of all images which took
 */

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/camera/showImagesAccordingToDate.dart';

import '../../Services/IamageStoreService.dart';
import '../../Theme/theme_info.dart';
import 'camera_tabview.dart';
import 'meal_view.dart';
import 'one_image_view_page.dart';

class listAccordingToDate extends StatelessWidget {
  late String date;
  late String meaTime;
  final imageStorage staorage = imageStorage();
  var image_path = <String>[]; // Creates growable list.

  listAccordingToDate(this.date,this.meaTime,String urlForDelete, {Key? key}){
    try{
      print("\n came to delete url = \n"+urlForDelete+"===================");
      //staorage.delete(urlForDelete);
      delete(urlForDelete);
      //staorage.deleteAfterExpire();
    }
    catch(e){
      print(e);
    }
  }
  Future <void> delete(String url) async{
    FirebaseStorage.instance.refFromURL(url).delete();
    //staorage.refFromURL(url).delete();
    //await staorage.delete(url);
  }
  //var files;
  @override
  Widget build(BuildContext context) {
    const title = 'Meal Gallery'; // main Title
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child:AppBar(
              title: Text(date+'   '+meaTime),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Menu Icon',
                onPressed: () {Navigator.of(context).push(MaterialPageRoute(
                    builder: (contex)
                    {//return CameraScreen(widget.cameras);
                      return tabviewcamera();
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
          ),
          body: FutureBuilder(
            future:staorage.getUrl(date.toString().split(' ')[0], meaTime),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // untill the data is load
                return const Center(
                  //child: Text('Waiting'),
                  child:
                  CircularProgressIndicator(backgroundColor: Colors.red,
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
                                      return showimage(snapshot.data[index],date,meaTime);
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

