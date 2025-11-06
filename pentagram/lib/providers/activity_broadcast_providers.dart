import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/activity_broadcast_service.dart';

final activityBroadcastServiceProvider = Provider<ActivityBroadcastService>((ref) => const ActivityBroadcastService());

class ActivityBroadcastState {
  final bool loading;
  final String? error;
  const ActivityBroadcastState({this.loading = false, this.error});
  ActivityBroadcastState copyWith({bool? loading, String? error}) =>
      ActivityBroadcastState(loading: loading ?? this.loading, error: error);
}

class ActivityBroadcastController extends StateNotifier<ActivityBroadcastState> {
  ActivityBroadcastController(this._ref) : super(const ActivityBroadcastState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _ref.read(activityBroadcastServiceProvider).refresh();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final activityBroadcastControllerProvider = StateNotifierProvider<ActivityBroadcastController, ActivityBroadcastState>((ref) => ActivityBroadcastController(ref));
