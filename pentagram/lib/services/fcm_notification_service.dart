import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for sending FCM notifications
/// This service integrates with Firebase Cloud Messaging to send push notifications
class FCMNotificationService {
  final FirebaseFirestore _firestore;

  FCMNotificationService(this._firestore);

  /// Send notification to a specific user/citizen
  /// This creates a pesan document and triggers a cloud function (if configured)
  /// to send the actual FCM notification
  Future<void> sendPesanNotification({
    required String citizenId,
    required String nama,
    required String pesan,
    String avatar = '-',
  }) async {
    try {
      // Create pesan document in Firestore
      await _firestore.collection('pesan').add({
        'nama': nama,
        'pesan': pesan,
        'waktu': DateTime.now().toIso8601String(),
        'unread': true,
        'avatar': avatar,
        'citizenId': citizenId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Get user's FCM token from citizens collection
      final citizenDoc = await _firestore.collection('citizens').doc(citizenId).get();
      final fcmToken = citizenDoc.data()?['fcmToken'] as String?;

      if (fcmToken != null && fcmToken.isNotEmpty) {
        // TODO: Send FCM notification via your backend API or Cloud Function
        // For now, we'll use a simpler approach with a notification document
        // that can be processed by a Cloud Function
        await _firestore.collection('notifications').add({
          'token': fcmToken,
          'title': 'Pesan Baru dari $nama',
          'body': pesan,
          'data': {
            'type': 'pesan',
            'citizenId': citizenId,
          },
          'createdAt': FieldValue.serverTimestamp(),
          'processed': false,
        });

      }
    } catch (e) {
      rethrow;
    }
  }

  /// Send broadcast notification to multiple users
  /// Uses FCM topic messaging for efficient delivery to multiple devices
  Future<void> sendBroadcastNotification({
    required String title,
    required String message,
    String topic = 'all_users',
  }) async {
    try {
      // Create broadcast notification document
      await _firestore.collection('notifications').add({
        'topic': topic,
        'title': title,
        'body': message,
        'data': {
          'type': 'broadcast',
        },
        'createdAt': FieldValue.serverTimestamp(),
        'processed': false,
      });

    } catch (e) {
      rethrow;
    }
  }

  /// Update citizen's FCM token
  Future<void> updateCitizenFCMToken(String citizenId, String fcmToken) async {
    try {
      await _firestore.collection('citizens').doc(citizenId).update({
        'fcmToken': fcmToken,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      rethrow;
    }
  }

  /// Update user's FCM token (based on users collection)
  Future<void> updateUserFCMToken(String userId, String fcmToken) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': fcmToken,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      rethrow;
    }
  }
}
