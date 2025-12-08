import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String? documentId;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final String? senderAvatar;

  ChatMessage({
    this.documentId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.senderAvatar,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      documentId: map['_docId'] as String?,
      senderId: map['senderId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? 'Unknown',
      message: map['message'] as String? ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      senderAvatar: map['senderAvatar'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'senderAvatar': senderAvatar,
    };
  }

  ChatMessage copyWith({
    String? documentId,
    String? senderId,
    String? senderName,
    String? message,
    DateTime? timestamp,
    String? senderAvatar,
  }) {
    return ChatMessage(
      documentId: documentId ?? this.documentId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      senderAvatar: senderAvatar ?? this.senderAvatar,
    );
  }
}
