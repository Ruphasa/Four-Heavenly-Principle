import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/penerimaan_warga_service.dart';

final penerimaanWargaServiceProvider = Provider<PenerimaanWargaService>((ref) => const PenerimaanWargaService());

class PenerimaanWargaState {
  final bool loading;
  final String? error;
  const PenerimaanWargaState({this.loading = false, this.error});
  PenerimaanWargaState copyWith({bool? loading, String? error}) =>
      PenerimaanWargaState(loading: loading ?? this.loading, error: error);
}

class PenerimaanWargaController extends StateNotifier<PenerimaanWargaState> {
  PenerimaanWargaController(this._ref) : super(const PenerimaanWargaState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _ref.read(penerimaanWargaServiceProvider).refresh();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final penerimaanWargaControllerProvider = StateNotifierProvider<PenerimaanWargaController, PenerimaanWargaState>((ref) => PenerimaanWargaController(ref));
