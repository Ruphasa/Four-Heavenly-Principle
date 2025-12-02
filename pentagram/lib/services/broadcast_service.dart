import 'package:pentagram/models/broadcast_message.dart';

class BroadcastService {
  static final BroadcastService _instance = BroadcastService._internal();
  factory BroadcastService() => _instance;
  BroadcastService._internal();

  // Legacy in-memory store is now intentionally empty to avoid dummy data.
  final List<BroadcastMessage> _messages = [];

  List<BroadcastMessage> getAllMessages() {
    return List.from(_messages);
  }

  List<BroadcastMessage> getUrgentMessages() {
    return _messages.where((msg) => msg.isUrgent).toList();
  }

  List<BroadcastMessage> getSentMessages() {
    return _messages;
  }

  Map<String, dynamic> getBroadcastStatistics() {
    final urgent = _messages.where((msg) => msg.isUrgent).length;
    final now = DateTime.now();
    final today = _messages.where((msg) {
      return msg.sentDate.year == now.year &&
          msg.sentDate.month == now.month &&
          msg.sentDate.day == now.day;
    }).length;

    return {
      'totalMessages': _messages.length,
      'sent': _messages.length,
      'urgent': urgent,
      'today': today,
    };
  }

  void sendBroadcast(BroadcastMessage message) {
    _messages.insert(0, message);
  }
}