/*
 this is for main tab view to take image part or view meal images
 */
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/dashboard_layout.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'CameraPage.dart';
import 'anotherDayMealImage.dart';
import 'meal_view.dart';
import 'package:mobile_app/Pages/camera/showImagesAccordingToDate.dart';
import 'list_of_images.dart';

class tabviewcamera extends StatelessWidget {
  const tabviewcamera({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(

            preferredSize: Size.fromHeight(90.0),
            child:AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'back',
                onPressed: () {Navigator.of(context).push(MaterialPageRoute(
                    builder: (contex)
                    {//return CameraScreen(widget.cameras);
                      return DashboardLayout();
                    })
                );
                },
              ),
            title: Text('Meal Gallery'),
            actions: <Widget>[

              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (contex)
                        {//return CameraScreen(widget.cameras);
                          return const mealIamgeAnotherDay();
                        })
                    );
                      },
                    child: Icon(
                        Icons.calendar_today
                    ),
                  )
              ),
            ],

            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.camera_alt)),
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
          body: const TabBarView(
            children: [
            campage(title: 'camera',),
              //mealview(),
              selectDateShowImage(),
              MyFileList(),

            ],
          ),
        ),
      ),
    );
  }
}