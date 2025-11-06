import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/profil_service.dart';

final profilServiceProvider = Provider<ProfilService>((ref) => const ProfilService());

class ProfilState {
  final bool loading;
  final String? error;
  const ProfilState({this.loading = false, this.error});
  ProfilState copyWith({bool? loading, String? error}) =>
      ProfilState(loading: loading ?? this.loading, error: error);
}

class ProfilController extends StateNotifier<ProfilState> {
  ProfilController(this._ref) : super(const ProfilState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _ref.read(profilServiceProvider).refresh();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final profilControllerProvider = StateNotifierProvider<ProfilController, ProfilState>((ref) => ProfilController(ref));
