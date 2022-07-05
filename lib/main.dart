import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/welcome_screen.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import "package:camera/camera.dart";
import 'Pages/dashboard_layout.dart';
import 'package:get/get.dart';
import 'package:mobile_app/LocaleString.dart';

List<CameraDescription> cameras = [];

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(const MyApp());
}

//void main() {
//  runApp(const MyApp());
//}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocalString(),
      locale: const Locale('en', 'US'), // default language - en-US
      debugShowCheckedModeBanner: false,
      title: 'SnaT',
      theme: ThemeData(
        primaryColor: ThemeInfo.primaryColor,
        primarySwatch: Colors.teal,
      ),
      //home: DashboardLayout(),
      home: WelcomeScreen(),
    );
  }
}
