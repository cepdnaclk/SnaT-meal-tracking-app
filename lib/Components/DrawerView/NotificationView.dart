import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_app/Pages/dashboard_layout.dart';
import 'package:mobile_app/Settings/notification_service.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late final NotificationService service;

  @override
  void initState() {
    service = NotificationService();
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
                await service.showNotification(
                    id: 0, title: 'General Notification', body: 'Just a Notification');
              },
              child: const Text('show notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                await service.showScheduledNotification(
                  id: 2,
                  title: 'title',
                  body: 'some body',
                  seconds: 10,
                );
              },
              child: const Text('show scheduled notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                await service.showDailyNotification(
                    id: 1,
                    title: 'daily notification',
                    body: 'Time is 9.52 a.m.',
                    time: const Time(9,52,0),
                );
              },
              child: const Text('show daily notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                await service.showNotificationWithPayload(
                    id: 3,
                    title: 'You Missed a Meal!',
                    body: 'Please, Enter Yesterday Breakfast Details!',
                    payload: 'payload navigation');
              },
              child: const Text('show notification with payload'),
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

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => DashboardLayout())));
    }
  }
}
