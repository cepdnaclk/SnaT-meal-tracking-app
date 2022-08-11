/*
 this is for main tab view to take image part or view meal images
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/Pages/camera/CameraPage.dart';
import 'package:mobile_app/Pages/dashboard_layout.dart';
import 'package:mobile_app/Theme/theme_info.dart';

import '../../Components/dashboard_drawer.dart';
import '../../Models/image_model.dart';
import 'camera_testing.dart';
import 'selectDateRange.dart';

class TabViewCamera extends StatefulWidget {
  const TabViewCamera({Key? key}) : super(key: key);

  @override
  State<TabViewCamera> createState() => _TabViewCameraState();
}

class _TabViewCameraState extends State<TabViewCamera>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentPageIndex = 0;
  bool showResult = false;
  ImageModel? takenImage;
  String title = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeInfo.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'back',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (contex) {
                //return CameraScreen(widget.cameras);
                return const DashboardLayout();
              }));
            },
          ),
          title: Text('Meal_Gallery'.tr),
        ),
        drawer: const DashboardDrawer(),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 1,
          color: ThemeInfo.primaryColor,
          child: TabBar(
            indicatorColor: ThemeInfo.bottomTabButtonColor,
            labelColor: ThemeInfo.bottomTabButtonColor,
            isScrollable: false,
            controller: _tabController,
            onTap: (val) {
              print(val);
            },
            tabs: const [
              Tab(
                icon: Icon(Icons.camera_alt),
              ),
              Tab(
                icon: Icon(Icons.find_in_page),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            showResult
                ? CamPage(
          takenImage: takenImage!,
          title: title,
        )
                :CameraTest(
              resultCallback: (ImageModel capturedImage) {
                takenImage = capturedImage;
                showResult = true;
                setState(() {});
              },
            ) ,
            Daterange(),
          ],
        ),
      ),
    );
  }
}

// class tabviewcamera extends StatelessWidget {
//   const tabviewcamera({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           appBar: PreferredSize(
//
//             preferredSize: Size.fromHeight(90.0),
//             child:AppBar(
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 tooltip: 'back',
//                 onPressed: () {Navigator.of(context).push(MaterialPageRoute(
//                     builder: (contex)
//                     {//return CameraScreen(widget.cameras);
//                       return DashboardLayout();
//                     })
//                 );
//                 },
//               ),
//             title: Text('Meal Gallery'),
//             actions: <Widget>[
//
//               Padding(
//                   padding: EdgeInsets.only(right: 20.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (contex)
//                         {//return CameraScreen(widget.cameras);
//                           return const mealIamgeAnotherDay();
//                         })
//                     );
//                       },
//                     child: Icon(
//                         Icons.calendar_today
//                     ),
//                   )
//               ),
//             ],
//
//             bottom: const TabBar(
//               tabs: [
//                 Tab(icon: Icon(Icons.camera_alt)),
//                 Tab(
//                   icon: Icon(Icons.find_in_page),
//                   // text: "grid",
//                 ),
//                 Tab(
//                   icon: Icon(Icons.grid_on_outlined),
//                   //text: "list"
//                 ),
//               ],
//             ),
//             titleSpacing: 00.0,
//             centerTitle: true,
//             toolbarHeight: 60.2,
//             toolbarOpacity: 0.8,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                   bottomRight: Radius.circular(25),
//                   bottomLeft: Radius.circular(25)),
//             ),
//             elevation: 0.00,
//             backgroundColor: ThemeInfo.primaryColor,
//           ),
//         ),
//           body: const TabBarView(
//             children: [
//             campage(title: 'camera',),
//               //mealview(),
//               selectDateShowImage(),
//               MyFileList(),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
