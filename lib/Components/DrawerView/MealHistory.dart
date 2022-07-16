import 'package:flutter/material.dart';
import 'package:mobile_app/Settings/ChangeAppLanguage.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:get/get.dart';

class MealHistory extends StatelessWidget {
  const MealHistory({Key? key}) : super(key: key);

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
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: false,
                leading: const Icon(Icons.format_paint),
                title: Text('customTheme'.tr),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
