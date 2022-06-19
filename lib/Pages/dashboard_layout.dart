import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Components/Tab_Views/chart_view.dart';
import 'package:mobile_app/Components/Tab_Views/home_view.dart';
import 'package:mobile_app/Components/Tab_Views/scheduling_view.dart';
import 'package:mobile_app/Components/Tab_Views/bmi_view.dart';
import 'package:mobile_app/Components/dashboard_drawer.dart';
import 'package:mobile_app/Pages/CameraPage.dart';
//import 'package:mobile_app/Pages/SchedulingView.dart';
import 'package:mobile_app/Theme/theme_info.dart';

class DashboardLayout extends StatefulWidget {
  //const DashboardLayout({Key? key}) : super(key: key);
  var cameras;
  DashboardLayout(this.cameras);
  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeInfo.primaryColor,
          title: const Text("SnaT: Meal Diary"),
        ),
        // button for camera from bottom Navigation Bar
        floatingActionButton: FloatingActionButton(
          heroTag: "btn1",
          child: const Icon(Icons.camera_alt_outlined),
          backgroundColor: ThemeInfo.primaryColor,
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (contex)
                    {//return CameraScreen(widget.cameras);
                      return const campage(title: 'camera',);
                    })
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                icon: Icon(
                  Icons.local_dining,
                ),
              ),
              Tab(
                icon: Icon(Icons.calendar_today),
              ),
              Tab(
                icon: Icon(Icons.insert_chart),
              ),
              Tab(
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            HomeView(),
            SchedulingView(),
            ChartView(),
            BmiCalcView(),
          ],
        ),
      ),
    );
  }
}
