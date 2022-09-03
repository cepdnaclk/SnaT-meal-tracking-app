import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/LocaleString.dart';
import 'package:mobile_app/Pages/dashboard_layout.dart';
import 'package:mobile_app/Pages/welcome_screen.dart';
import 'package:mobile_app/Theme/theme_info.dart';

import 'Settings/notification_service.dart';
import 'constants.dart';

late List<CameraDescription> cameras;
User? user = FirebaseAuth.instance.currentUser;
late final NotificationService service;
late String notificationBody;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();

  // notification initialize
  service = NotificationService();
  await service.initialize();
  print("notification service initialized\n");
  runApp(const MyApp());
  if (user != null) generateNotification();
}

String getMissingFoodData() {
  user = FirebaseAuth.instance.currentUser;
  String uid;

  if (user != null) {
    uid = user!.uid;
  } else {
    uid = '';
  }
  DateTime now = DateTime.now();
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final yesterday_date = yesterday.toString().substring(0, 10);
  getYesterdayMissedMealTimes(yesterday_date);
  return notificationBody;
}

getYesterdayMissedMealTimes(String yesterday_date) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection('foodLog')
      .doc(yesterday_date)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      Map numMap = (documentSnapshot.data() as Map);
      var consumedMealTimes = <String>{};
      for (var v in numMap.keys) {
        print(v.toString());
        consumedMealTimes.add(v);
      }
      final List<String> consumedFood = consumedMealTimes.toList();
      List<String> difference =
          mealTimes.toSet().difference(consumedFood.toSet()).toList();
      print(difference.toString());
      notificationBody = difference.toString();
      print(notificationBody);
    } else {
      notificationBody =
          "You didn't keep track of Mealtimes yesterday. Please keep track of your Mealtimes";
      print(notificationBody);
    }
  });
}

void generateNotification() async {
  await service.showDailyNotification(
    id: 1,
    title: "Daily Notification",
    body: getMissingFoodData(),
  );
  print('scheduled notification');
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

      home: user != null ? const DashboardLayout() : const WelcomeScreen(),
    );
  }
}
