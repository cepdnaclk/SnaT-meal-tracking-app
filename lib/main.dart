import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/LocaleString.dart';
import 'package:mobile_app/Pages/dashboard_layout.dart';
import 'package:mobile_app/Pages/welcome_screen.dart';
import 'package:mobile_app/Theme/theme_info.dart';

//List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocalString(),
      locale: const Locale(
        'en',
        'US',
      ), // default language - en-US
      debugShowCheckedModeBanner: false,
      title: 'SnaT',
      theme: ThemeData(
        primaryColor: ThemeInfo.primaryColor,
        backgroundColor: ThemeInfo.primaryBGColor,
        primarySwatch: Colors.teal,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: ThemeInfo.appAndBottomBarColor,
        ),
        appBarTheme: AppBarTheme(
          color: ThemeInfo.appAndBottomBarColor,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: ThemeInfo.appAndBottomBarColor,
        ),
      ),

      home: user == null ? const WelcomeScreen() : const DashboardLayout(),
    );
  }
}
