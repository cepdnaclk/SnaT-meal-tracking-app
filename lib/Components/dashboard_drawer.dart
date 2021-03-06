import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Components/DrawerView/NotificationView.dart';
import 'package:mobile_app/Components/DrawerView/SettingsView.dart';
import 'package:mobile_app/Components/DrawerView/MealHistory.dart';

import '../Theme/theme_info.dart';

final _firestore = FirebaseFirestore.instance;
User? user = FirebaseAuth.instance.currentUser;
String? email = user?.email.toString();
String? name = user?.displayName.toString();

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        color: ThemeInfo.primaryColor,
        padding: EdgeInsets.only(
          top: 25 + MediaQuery.of(context).padding.top,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 52,
              backgroundImage: AssetImage('assets/images/userImage.png'),
            ),
            SizedBox(height: 15),
            ListTile(
              title: Text(name!),
              subtitle: Text(email!),
            )
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListTile(
              iconColor: Colors.greenAccent,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              leading: const Icon(Icons.history_toggle_off_rounded),
              title: const Text('Meal History',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MealHistory()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListTile(
              iconColor: Colors.blueGrey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              leading: const Icon(Icons.settings_rounded),
              title: const Text('Settings',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsView()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListTile(
              iconColor: Colors.amberAccent,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              leading: const Icon(Icons.camera),
              title: const Text('Camera',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () {
                // Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListTile(
              iconColor: Colors.redAccent,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              leading: const Icon(Icons.notification_add_outlined),
              title: const Text('Notifications',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationView()));
              },
            ),
          ),
          Wrap(
            runAlignment: WrapAlignment.end,
            children: [
              const Divider(
                color: Colors.blueGrey,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                  iconColor: Colors.blueAccent,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign Out',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                  onTap: () {
                    // Navigator.pop(context);
                  },
                ),
              ),
            ],
          )
        ],
      );
}
