import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
  AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  Future<void> init(BuildContext context) async {
    // Local notification init
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _local.initialize(settings);

    await _local
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Permission
    NotificationSettings permission =
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("✅ Permission: ${permission.authorizationStatus}");

    // Token
    String? token = await _messaging.getToken();
    print("🔑 FCM TOKEN: $token");

    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 FOREGROUND MESSAGE RECEIVED");
      print("DATA: ${message.data}");
      print("NOTIFICATION: ${message.notification}");

      String title =
          message.notification?.title ?? message.data['title'] ?? "";
      String body =
          message.notification?.body ?? message.data['body'] ?? "";

      if (title.isNotEmpty || body.isNotEmpty) {
        showNotification(title, body);
      }
    });

    // When app opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📲 Notification Clicked");
    });
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}