import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/broadcast_service.dart';

final broadcastServiceProvider = Provider<BroadcastService>((ref) => BroadcastService());

class BroadcastState {
  final bool loading;
  final String? error;
  const BroadcastState({this.loading = false, this.error});
  BroadcastState copyWith({bool? loading, String? error}) =>
      BroadcastState(loading: loading ?? this.loading, error: error);
}

class BroadcastController extends StateNotifier<BroadcastState> {
  BroadcastController(this._ref) : super(const BroadcastState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      // Sync data access example; replace with async API if available
      _ref.read(broadcastServiceProvider).getAllMessages();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final broadcastControllerProvider = StateNotifierProvider<BroadcastController, BroadcastState>((ref) => BroadcastController(ref));
