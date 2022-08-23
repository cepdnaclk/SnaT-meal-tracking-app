import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_app/Pages/dashboard_layout.dart';
import 'package:mobile_app/Settings/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/constants.dart';

User? user = FirebaseAuth.instance.currentUser;

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late final NotificationService service;

  void getMissingFoodData() {
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
      } else {
        print(
            "You didn't keep track of Mealtimes yesterday. Please keep track of your Mealtimes");
      }
    });
  }

  @override
  void initState() {
    service = NotificationService();
    getMissingFoodData();
    service.initialize();
    listenToNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [


            ElevatedButton(
              onPressed: () async {
                await service.showDailyNotification(
                  id: 1,
                  title: 'daily notification',
                  body: 'Time is 9.52 a.m.',
                  time: const Time(9, 52, 0),
                );
              },
              child: const Text('show daily notification'),
            ),

            ElevatedButton(
              onPressed: () async {
                await service.cancelAllNotifications();
              },
              child: const Text('cancel notification'),
            ),
          ],
        ),
      ),
    );
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => DashboardLayout())));
    }
  }
}
