import 'package:flutter_riverpod/flutter_riverpod.dart';

class BroadcastState {
  final bool loading;
  final String? error;
  const BroadcastState({this.loading = false, this.error});
  BroadcastState copyWith({bool? loading, String? error}) =>
      BroadcastState(loading: loading ?? this.loading, error: error);
}

class BroadcastController extends StateNotifier<BroadcastState> {
  BroadcastController(Ref ref) : super(const BroadcastState());
  
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      // No-op: Firestore streams handle broadcast updates reactively
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final broadcastControllerProvider = StateNotifierProvider<BroadcastController, BroadcastState>((ref) => BroadcastController(ref));
