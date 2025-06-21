import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../db_helper/send_notification_service.dart';

class NotificationPracticeView extends StatefulWidget {
  const NotificationPracticeView({Key? key}) : super(key: key);

  @override
  State<NotificationPracticeView> createState() => _NotificationPracticeViewState();
}

class _NotificationPracticeViewState extends State<NotificationPracticeView> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Use the correct icon name
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }


  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'your_channel_id', 'Your Channel Name',
        channelDescription: 'Your Channel Description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        0, 'Plain Title', 'Plain Body', platformChannelSpecifics,
        payload: 'item x');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Practice"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _showNotification,
              child: const Text("Show Notification"),
            ),

            ElevatedButton(
              onPressed: ()async{
                await SendNotificationService.sendNotificationUsingApi(
                  token: "frCmyBjyTrimgf5nk2Q0ti:APA91bHxZe-1slVFQWlEu0H0ZFbzjcc9IoFzKcYaw9ib8PDEG_wSuqZIMy4vujQbV-ZLhW5OB-WL10NU9qIjS00TJTofFWhcBlrybZYyurAs50QhCwfGfw8",
                  title: "Your book buying request accepted",
                  body: "Tap to view the notification",
                  data: {
                    "screen": "NotificationView", // This is for navigation when tapped
                  },
                );
              },
              child: const Text("Show Notification"),
            ),
          ],
        ),
      ),
    );
  }
}