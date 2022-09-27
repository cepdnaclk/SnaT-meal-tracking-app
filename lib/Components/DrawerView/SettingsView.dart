import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/Pages/user_profile.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../Settings/ChangeAppLanguage.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ThemeInfo.primaryColor,
        title: Text('settings'.tr),
      ),
      body: SettingsList(
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(
            title: const Text('User Profile'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfilePage(),
                    ),
                  );
                },
                leading: const Icon(Icons.person),
                title: const Text('User Information'),
              ),
            ],
          ),

          SettingsSection(
            title: Text('common'.tr),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                onPressed: (context) {
                  var changelanguage =
                      ChangeLanguage().buildLanguageDialog(context);
                },
                leading: const Icon(Icons.language),
                title: Text('language'.tr),
              ),
            ],
          ),

          // SettingsSection(
          //   title: Text('Notification'.tr),
          //   tiles: <SettingsTile>[
          //     SettingsTile.navigation(
          //       onPressed: (context) {},
          //       leading: const Icon(Icons.language),
          //       title: const Text('Cancel Notifications'),
          //     ),
          //     SettingsTile.switchTile(
          //       onToggle: (value) {},
          //       initialValue: false,
          //       leading: const Icon(Icons.format_paint),
          //       title: const Text('Schedule Daily Notification'),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
