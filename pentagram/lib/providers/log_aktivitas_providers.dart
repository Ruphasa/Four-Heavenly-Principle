import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/activity_log_service.dart';

final activityLogServiceProvider = Provider<ActivityLogService>((ref) => ActivityLogService());

class LogAktivitasState {
  final bool loading;
  final String? error;
  const LogAktivitasState({this.loading = false, this.error});
  LogAktivitasState copyWith({bool? loading, String? error}) =>
      LogAktivitasState(loading: loading ?? this.loading, error: error);
}

class LogAktivitasController extends StateNotifier<LogAktivitasState> {
  LogAktivitasController(this._ref) : super(const LogAktivitasState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      _ref.read(activityLogServiceProvider).getAllActivityLogs();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final logAktivitasControllerProvider = StateNotifierProvider<LogAktivitasController, LogAktivitasState>((ref) => LogAktivitasController(ref));
