import 'package:flutter/material.dart';


import '../Theme/theme_info.dart';

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


  Widget buildHeader(BuildContext context) =>
      Container(
        color: Colors.cyan[100],
        padding: EdgeInsets.only(
          top: 25 + MediaQuery.of(context).padding.top,
        ),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 52,
              backgroundImage: AssetImage('assets/images/userImage.png'),
            ),
            SizedBox(height: 15),
            ListTile(
              title: Text('Unknown User'),
              subtitle: Text('unknown@email.com'),
            )
          ],
        ),
      );


  Widget buildMenuItems(BuildContext context) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListTile(
              iconColor: Colors.blueGrey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              leading: const Icon(Icons.history_toggle_off_rounded),
              title: const Text(
                  'Meal History',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
              onTap: () {
                // Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListTile(
              iconColor: Colors.blueGrey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              leading: const Icon(Icons.settings_rounded),
              title: const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
              onTap: () {
                //
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListTile(
              iconColor: Colors.blueGrey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              leading: const Icon(Icons.camera),
              title: const Text(
                  'Camera',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
              onTap: () {
                // Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListTile(
              iconColor: Colors.blueGrey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              leading: const Icon(Icons.notification_add_outlined),
              title: const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
              onTap: () {
                // Navigator.pop(context);
              },
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children:  [
              const Divider(color: Colors.blueGrey,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                  iconColor: Colors.blueGrey,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  leading: const Icon(Icons.logout),
                  title: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )
                  ),
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
