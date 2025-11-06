import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/manajemen_pengguna_service.dart';

final manajemenPenggunaServiceProvider = Provider<ManajemenPenggunaService>((ref) => const ManajemenPenggunaService());

class ManajemenPenggunaState {
  final bool loading;
  final String? error;
  const ManajemenPenggunaState({this.loading = false, this.error});
  ManajemenPenggunaState copyWith({bool? loading, String? error}) =>
      ManajemenPenggunaState(loading: loading ?? this.loading, error: error);
}

class ManajemenPenggunaController extends StateNotifier<ManajemenPenggunaState> {
  ManajemenPenggunaController(this._ref) : super(const ManajemenPenggunaState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _ref.read(manajemenPenggunaServiceProvider).refresh();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final manajemenPenggunaControllerProvider = StateNotifierProvider<ManajemenPenggunaController, ManajemenPenggunaState>((ref) => ManajemenPenggunaController(ref));
