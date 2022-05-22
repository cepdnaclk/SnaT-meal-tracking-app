import 'package:flutter/material.dart';

import '../Theme/theme_info.dart';
import 'drawer_tab.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: ThemeInfo.primaryColor,
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: const [
                    SizedBox(
                      width: 20,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 30,
                      backgroundImage:
                          AssetImage("assets/images/userImage.png"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "John Doe",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: const [
                      Text(
                        "Details",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Spacer(),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.white,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const DrawerTab(
            icon: Icons.history_toggle_off,
            label: "Meal History",
          ),
          const DrawerTab(
            icon: Icons.settings,
            label: "Settings",
          ),
          const DrawerTab(
            icon: Icons.camera_alt,
            label: "Cameras",
          ),
          const DrawerTab(
            icon: Icons.alternate_email,
            label: "Contact Us",
          ),
        ],
      ),
    );
  }
}
