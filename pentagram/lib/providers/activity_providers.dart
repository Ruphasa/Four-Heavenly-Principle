import 'package:flutter_riverpod/flutter_riverpod.dart';
// Legacy ActivityService removed; providers now rely on Firestore streams.

// Removed ActivityService provider to eliminate dummy data dependency.

class ActivityState {
  final bool loading;
  final String? error;
  const ActivityState({this.loading = false, this.error});
  ActivityState copyWith({bool? loading, String? error}) =>
      ActivityState(loading: loading ?? this.loading, error: error);
}

class ActivityController extends StateNotifier<ActivityState> {
  ActivityController(Ref ref) : super(const ActivityState());
  
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      // No-op: Firestore streams update UI reactively.
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final activityControllerProvider = StateNotifierProvider<ActivityController, ActivityState>((ref) => ActivityController(ref));
