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
          right: 10,
          left: 10,
        ),
        child: Column(
          children: [
            Center(
              child: user!.photoURL != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user!.photoURL!),
                    )
                  : const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/images/userImage.png'),
                    ),
            ),
            const SizedBox(height: 15),
            Text(
              name!,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10),
                iconColor: Colors.greenAccent,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                leading: const Icon(Icons.history_toggle_off_rounded),
                horizontalTitleGap: 0,
                title: const Text('Meal History',
                    style: TextStyle(
                      fontSize: 20.0,
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
                contentPadding: const EdgeInsets.only(left: 10),
                iconColor: Colors.blueGrey,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                leading: const Icon(Icons.settings_rounded),
                horizontalTitleGap: 0,
                title: const Text('Settings',
                    style: TextStyle(
                      fontSize: 20.0,
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
                contentPadding: const EdgeInsets.only(left: 10),
                iconColor: Colors.amberAccent,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                leading: const Icon(Icons.camera),
                horizontalTitleGap: 0,
                title: const Text('Camera',
                    style: TextStyle(
                      fontSize: 20.0,
                    )),
                onTap: () {
                  // Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10),
                iconColor: Colors.redAccent,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                leading: const Icon(Icons.notification_add_outlined),
                horizontalTitleGap: 0,
                title: const Text('Notifications',
                    style: TextStyle(
                      fontSize: 20.0,
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationView()));
                },
              ),
            ),
            const Spacer(),
            const Divider(
              color: Colors.blueGrey,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ListTile(
                horizontalTitleGap: 0,
                contentPadding: const EdgeInsets.only(left: 10),
                iconColor: Colors.blueAccent,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out',
                    style: TextStyle(
                      fontSize: 20.0,
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
                },
              ),
            )
          ],
        ),
      );
}
