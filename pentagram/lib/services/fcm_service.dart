import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Firebase Cloud Messaging Service for handling push notifications
class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize FCM and request permissions
  Future<void> initialize() async {
    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }

    // Handle token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      if (kDebugMode) {
        print('FCM Token refreshed: $newToken');
      }
      // TODO: Send new token to server if needed
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Check if app was opened from a terminated state
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Foreground message received: ${message.messageId}');
      print('Notification: ${message.notification?.title}');
      print('Data: ${message.data}');
    }
    // Notification will be shown automatically by FCM
  }

  /// Handle notification tap
  void _handleMessageOpenedApp(RemoteMessage message) {
    if (kDebugMode) {
      print('Message clicked: ${message.messageId}');
      print('Data: ${message.data}');
    }
    // TODO: Navigate to specific screen based on message data
  }

  /// Get FCM token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    if (kDebugMode) {
      print('Subscribed to topic: $topic');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    if (kDebugMode) {
      print('Unsubscribed from topic: $topic');
    }
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    if (kDebugMode) {
      print('FCM token deleted');
    }
  }
}

/// Top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Background message received: ${message.messageId}');
    print('Notification: ${message.notification?.title}');
    print('Data: ${message.data}');
  }
}
