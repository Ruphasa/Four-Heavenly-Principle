class BroadcastMessage {
  final int id;
  final String title;
  final String content;
  final String category;
  final bool isUrgent;
  final String sender;
  final DateTime sentDate;
  final int recipientCount;
  final int readCount;
  final List<String> recipients;

  BroadcastMessage({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.isUrgent,
    required this.sender,
    required this.sentDate,
    required this.recipientCount,
    required this.readCount,
    required this.recipients,
  });
}