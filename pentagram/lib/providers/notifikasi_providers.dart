import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/notifikasi_service.dart';

final notifikasiServiceProvider = Provider<NotifikasiService>((ref) => const NotifikasiService());

class NotifikasiState {
  final bool loading;
  final String? error;
  const NotifikasiState({this.loading = false, this.error});
  NotifikasiState copyWith({bool? loading, String? error}) =>
      NotifikasiState(loading: loading ?? this.loading, error: error);
}

class NotifikasiController extends StateNotifier<NotifikasiState> {
  NotifikasiController(this._ref) : super(const NotifikasiState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _ref.read(notifikasiServiceProvider).refresh();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final notifikasiControllerProvider = StateNotifierProvider<NotifikasiController, NotifikasiState>((ref) => NotifikasiController(ref));
