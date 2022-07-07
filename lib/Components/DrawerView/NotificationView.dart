import 'package:flutter/material.dart';
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
                    id: 0, title: 'title', body: 'somebody');
              },
              child: const Text('show notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                await service.showScheduledNotification(
                  id: 0,
                  title: 'title',
                  body: 'somebody',
                  seconds: 4,
                );
              },
              child: const Text('show scheduled notification'),
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text('show notification with payload'),
            ),
          ],
        ),
      ),
    );
  }
}
