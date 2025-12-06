import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/fcm_service.dart';
import 'package:pentagram/services/fcm_notification_service.dart';
import 'package:pentagram/providers/firestore_providers.dart';

/// Provider for FCM Service
final fcmServiceProvider = Provider<FCMService>((ref) {
  return FCMService();
});

/// Provider for FCM Token
final fcmTokenProvider = FutureProvider<String?>((ref) async {
  final fcmService = ref.watch(fcmServiceProvider);
  return await fcmService.getToken();
});

/// Provider for FCM Notification Service
final fcmNotificationServiceProvider = Provider<FCMNotificationService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FCMNotificationService(firestore);
});
