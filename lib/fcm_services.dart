import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final String userId;
  NotificationService({required this.userId});
  
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;


  Future<void> init() async {
    // Request permissions
    await _messaging.requestPermission();

    // Get and store token
    final token = await _messaging.getToken();
    print('FCM Token: $token');

    // Send token to your backend
    await FcmDatabaseRequest.sendTokenToBackend(token, userId);

    // Foreground handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Message received: ${message.notification!.title}');
        // Optionally show local notification here
      }
    });
  }

  
}
