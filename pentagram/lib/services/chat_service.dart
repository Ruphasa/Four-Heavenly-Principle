class ChatService {
  const ChatService();

  Future<void> refresh() async {
    // No-op: Firestore streams handle chat updates reactively
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String message,
    String? senderAvatar,
  }) async {
    // Will be implemented with Firestore
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> markAsRead(String conversationId, String userId) async {
    // Mark all messages in conversation as read
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
