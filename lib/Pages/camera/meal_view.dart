/*
 this is for tab view for gallery change between list view and grid view hadel by this
 */
import 'package:flutter/material.dart';
import 'list_image_ScrollView.dart';
import 'list_of_images.dart';

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
                     icon: Icon(Icons.grid_on_outlined),
                   // text: "grid",
                  ),
                  Tab(
                     icon: Icon(Icons.line_weight_sharp),
                     //text: "list"
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    MyFileList(),
                    ScrollViewlist(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}