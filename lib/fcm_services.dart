import 'dart:convert';
import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:next_gen_ai_healthcare/main.dart';

class NotificationService {
  final User user;
  NotificationService({required this.user});

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Local notifications plugin instance
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize local notifications for Android
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    await _localNotificationsPlugin.initialize(initSettings);

    // Request FCM permissions
    await _messaging.requestPermission();

    // Get and send FCM token
    final token = await _messaging.getToken();
    print('FCM Token: $token');

    await FcmDatabaseRequest.sendTokenToBackend(token, user.userId);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📥 Foreground message: ${message.notification!.title}');
      if (message.notification != null) {

        _localNotificationsPlugin.show(
          0,
          message.notification!.title ?? 'Notification',
          message.notification!.body ?? '',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'request_status_channel', // channel ID
              'Request Status Updates', // channel name
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    // Handle background/tapped notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🚪 Notification tapped. App opened.');
      // You can navigate here using message.data if needed
    });
  }
}
