import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Pages/welcome_screen.dart';
import 'package:mobile_app/Theme/theme_info.dart';
import "package:camera/camera.dart";



<<<<<<< HEAD
Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
=======
void main() {
>>>>>>> c3e7491dd94d0e82b1b2ad2eb4c9e79ec12ea846
  runApp(const MyApp());
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
      home:  WelcomeScreen(),
    );
  }
}
