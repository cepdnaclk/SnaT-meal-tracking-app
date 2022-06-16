import 'package:flutter/material.dart';
import 'package:mobile_app/Components/Tab_Views/chart_view.dart';
import 'package:mobile_app/Components/Tab_Views/home_view.dart';
import 'package:mobile_app/Components/Tab_Views/scheduling_view.dart';
import 'package:mobile_app/Components/Tab_Views/settings_view.dart';
import 'package:mobile_app/Components/dashboard_drawer.dart';

//import 'package:mobile_app/Pages/SchedulingView.dart';
import 'package:mobile_app/Theme/theme_info.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({Key? key}) : super(key: key);

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
        child: const Icon(Icons.camera_alt_outlined),
        backgroundColor: ThemeInfo.primaryColor,
        onPressed:(){},
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
            tabs:  [
              const Tab(
                icon: Icon(
                  Icons.local_dining,
                ),
              ),
              const Tab(
                icon: Icon(Icons.calendar_today),
              ),
              const Tab(
                icon: Icon(Icons.insert_chart),
              ),
              Tab(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                      'assets/images/bmi_icon.png',
                    color: Colors.white,
                    height: 28.0,
                    width: 28.0,
                  ),
                )
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
            SettingsView(),
          ],
        ),
      ),
    );
  }
}
