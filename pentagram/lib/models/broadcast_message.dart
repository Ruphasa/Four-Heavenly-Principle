import 'package:cloud_firestore/cloud_firestore.dart';

class BroadcastMessage {
  final String? documentId;
  final int id;
  final String title;
  final String content;
  final String category;
  final bool isUrgent;
  final String sender;
  final String? channelId; // relation to channels
  final String? senderUserId; // relation to users
  final DateTime sentDate;
  final int recipientCount;
  final int readCount;
  final List<String> recipients;

  BroadcastMessage({
    this.documentId,
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.isUrgent,
    required this.sender,
    this.channelId,
    this.senderUserId,
    required this.sentDate,
    required this.recipientCount,
    required this.readCount,
    required this.recipients,
  });

  factory BroadcastMessage.fromMap(Map<String, dynamic> map) {
    final rawDate = map['sentDate'];
    late final DateTime parsedDate;
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is DateTime) {
      parsedDate = rawDate;
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    final rawId = map['id'] ?? 0;
    final intId = rawId is num ? rawId.toInt() : int.tryParse(rawId.toString()) ?? 0;

    final recipients = (map['recipients'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];

    return BroadcastMessage(
      documentId: map['_docId'] as String?,
      id: intId,
      title: (map['title'] ?? '-') as String,
      content: (map['content'] ?? '') as String,
      category: (map['category'] ?? '-') as String,
      isUrgent: (map['isUrgent'] as bool?) ?? false,
      sender: (map['sender'] ?? '-') as String,
      channelId: map['channelId'] as String?,
      senderUserId: map['senderUserId'] as String?,
      sentDate: parsedDate,
      recipientCount: ((map['recipientCount'] ?? 0) as num).toInt(),
      readCount: ((map['readCount'] ?? 0) as num).toInt(),
      recipients: recipients,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'isUrgent': isUrgent,
      'sender': sender,
      'channelId': channelId,
      'senderUserId': senderUserId,
      'sentDate': Timestamp.fromDate(sentDate),
      'recipientCount': recipientCount,
      'readCount': readCount,
      'recipients': recipients,
    };
  }
}