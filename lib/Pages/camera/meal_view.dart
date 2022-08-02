/*
 this is for tab view for gallery change between
 searching meal images
  according to date and meal time
  and grid view hadele by this
 */
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/camera/showImagesAccordingToDate.dart';
import 'list_of_images.dart';

// delete---------------==================================================================================================

class mealview extends StatelessWidget {
  const mealview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: null,
          body: Column(
            children: [
              const TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.green,
                labelPadding: EdgeInsets.all(0),
                unselectedLabelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                tabs: [
                  Tab(
                     icon: Icon(Icons.find_in_page),
                   // text: "grid",
                  ),
                  Tab(
                     icon: Icon(Icons.grid_on_outlined),
                     //text: "list"
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    selectDateShowImage(),
                    //MyFileList(),

                    //ScrollViewlist(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
