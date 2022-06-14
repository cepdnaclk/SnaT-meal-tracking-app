import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/welcome_screen.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import "package:camera/camera.dart";


List<CameraDescription> cameras=[];

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(new MyApp());
}


// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SnaT',
      theme: ThemeData(
        primaryColor: ThemeInfo.primaryColor,
        primarySwatch: Colors.green,
      ),
      home:  WelcomeScreen(cameras),
    );
  }
}
