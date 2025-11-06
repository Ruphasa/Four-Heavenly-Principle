import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/mutasi_keluarga_service.dart';

final mutasiKeluargaServiceProvider = Provider<MutasiKeluargaService>((ref) => const MutasiKeluargaService());

class MutasiKeluargaState {
  final bool loading;
  final String? error;
  const MutasiKeluargaState({this.loading = false, this.error});
  MutasiKeluargaState copyWith({bool? loading, String? error}) =>
      MutasiKeluargaState(loading: loading ?? this.loading, error: error);
}

class MutasiKeluargaController extends StateNotifier<MutasiKeluargaState> {
  MutasiKeluargaController(this._ref) : super(const MutasiKeluargaState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _ref.read(mutasiKeluargaServiceProvider).refresh();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final mutasiKeluargaControllerProvider = StateNotifierProvider<MutasiKeluargaController, MutasiKeluargaState>((ref) => MutasiKeluargaController(ref));
