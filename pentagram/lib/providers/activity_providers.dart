import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/activity_service.dart';

final activityServiceProvider = Provider<ActivityService>((ref) => ActivityService());

class ActivityState {
  final bool loading;
  final String? error;
  const ActivityState({this.loading = false, this.error});
  ActivityState copyWith({bool? loading, String? error}) =>
      ActivityState(loading: loading ?? this.loading, error: error);
}

class ActivityController extends StateNotifier<ActivityState> {
  ActivityController(this._ref) : super(const ActivityState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      // Sync data access via ActivityService; adjust if async later
      _ref.read(activityServiceProvider).getUpcomingActivities();
      _ref.read(activityServiceProvider).getActivityStatistics();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final activityControllerProvider = StateNotifierProvider<ActivityController, ActivityState>((ref) => ActivityController(ref));
