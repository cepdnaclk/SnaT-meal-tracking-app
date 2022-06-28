/*
 this is for main tab view to take image part or view meal images
 */
import 'package:flutter/material.dart';
import 'CameraPage.dart';
import 'meal_view.dart';

class tabviewcamera extends StatelessWidget {
  const tabviewcamera({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Mael Gallery'),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.camera_alt)),
                Tab(icon: Icon(Icons.browse_gallery_sharp))
              ],
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
            backgroundColor: Colors.greenAccent[400],
          ),
          body: const TabBarView(
            children: [
            campage(title: 'camera',),
              mealview(),
            ],
          ),
        ),
      ),
    );
  }
}