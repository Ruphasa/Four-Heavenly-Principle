import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/pesan_service.dart';

final pesanServiceProvider = Provider<PesanService>((ref) => const PesanService());

class PesanState {
  final bool loading;
  final String? error;
  const PesanState({this.loading = false, this.error});
  PesanState copyWith({bool? loading, String? error}) =>
      PesanState(loading: loading ?? this.loading, error: error);
}

class PesanController extends StateNotifier<PesanState> {
  PesanController(this._ref) : super(const PesanState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _ref.read(pesanServiceProvider).refresh();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final pesanControllerProvider = StateNotifierProvider<PesanController, PesanState>((ref) => PesanController(ref));
