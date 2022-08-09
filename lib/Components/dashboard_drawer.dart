import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Components/DrawerView/MealHistory.dart';
import 'package:mobile_app/Components/DrawerView/NotificationView.dart';
import 'package:mobile_app/Components/DrawerView/SettingsView.dart';
import 'package:mobile_app/Pages/login_screen.dart';

import '../Pages/welcome_screen.dart';
import '../Theme/theme_info.dart';

final _firestore = FirebaseFirestore.instance;
String? email = user?.email.toString();
String? name = user?.displayName.toString();
Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context),
          buildMenuItems(context),
        ],
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
            const CircleAvatar(
              radius: 52,
              backgroundImage: AssetImage('assets/images/userImage.png'),
            ),
            const SizedBox(height: 15),
            ListTile(
              title: Text(name!),
              subtitle: Text(email!),
            )
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Expanded(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ListTile(
                iconColor: Colors.black,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: 0,
                leading: const Icon(Icons.history_toggle_off_rounded),
                title: const Text('Meal History',
                    style: TextStyle(
                      fontSize: 18.0,
                    )),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MealHistory()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ListTile(
                iconColor: Colors.black,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                horizontalTitleGap: 0,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.settings_rounded),
                title: const Text('Settings',
                    style: TextStyle(
                      fontSize: 18.0,
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
                iconColor: Colors.black,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: 0,
                leading: const Icon(Icons.notification_add_outlined),
                title: const Text('Notifications',
                    style: TextStyle(
                      fontSize: 18.0,
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationView()));
                },
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            const Spacer(),
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
                    Future logout() async {
                      await FirebaseAuth.instance.signOut().then((value) =>
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (route) => false));
                    }

                    logout();
                  }),
            )
          ],
        ),
      );
}
