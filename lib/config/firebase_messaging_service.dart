import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:tarsheed/services/firebase/firebase_service.dart';

class FirebaseMessagingService {
  static void setupFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedHandler);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessageHandler);
  }

  static Future<void> _onMessageHandler(RemoteMessage message) async {
    // Handle foreground message
    if (kDebugMode) {
      print('Foreground message received: ${message.notification?.title}');
    }
  }

  static Future<void> _onMessageOpenedHandler(RemoteMessage message) async {
    // Handle message opened from a terminated state
    if (kDebugMode) {
      print('Message opened: ${message.notification?.title}');
    }
  }

  static Future<void> _onBackgroundMessageHandler(RemoteMessage message) async {
    // Handle background message
    if (kDebugMode) {
      print('Background message received: ${message.notification?.title}');
    }
  }

  static Future<void> updateFcmToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await FirebaseService().updateFcmToken(fcmToken);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error updating FCM token: $e\n$stackTrace');
      }
    }
  }
}
