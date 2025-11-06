import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/dashboard_service.dart';

final dashboardServiceProvider = Provider<DashboardService>((ref) => const DashboardService());

class DashboardState {
  final bool loading;
  final String? error;
  const DashboardState({this.loading = false, this.error});
  DashboardState copyWith({bool? loading, String? error}) =>
      DashboardState(loading: loading ?? this.loading, error: error);
}

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController(this._ref) : super(const DashboardState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _ref.read(dashboardServiceProvider).refresh();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final dashboardControllerProvider = StateNotifierProvider<DashboardController, DashboardState>((ref) => DashboardController(ref));
