import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/chat_service.dart';

final chatServiceProvider = Provider<ChatService>((ref) => const ChatService());

class ChatState {
  final bool loading;
  final String? error;
  final bool sending;

  const ChatState({this.loading = false, this.error, this.sending = false});

  ChatState copyWith({bool? loading, String? error, bool? sending}) {
    return ChatState(
      loading: loading ?? this.loading,
      error: error,
      sending: sending ?? this.sending,
    );
  }
}

class ChatController extends StateNotifier<ChatState> {
  ChatController(this._ref) : super(const ChatState());
  final Ref _ref;

  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _ref.read(chatServiceProvider).refresh();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String message,
    String? senderAvatar,
  }) async {
    state = state.copyWith(sending: true, error: null);
    try {
      await _ref
          .read(chatServiceProvider)
          .sendMessage(
            conversationId: conversationId,
            senderId: senderId,
            senderName: senderName,
            message: message,
            senderAvatar: senderAvatar,
          );
      state = state.copyWith(sending: false);
    } catch (e) {
      state = state.copyWith(sending: false, error: e.toString());
    }
  }

  Future<void> markAsRead(String conversationId, String userId) async {
    try {
      await _ref.read(chatServiceProvider).markAsRead(conversationId, userId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final chatControllerProvider = StateNotifierProvider<ChatController, ChatState>(
  (ref) => ChatController(ref),
);
