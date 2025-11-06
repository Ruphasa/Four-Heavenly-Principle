import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/register_service.dart';

final registerServiceProvider = Provider<RegisterService>((ref) => const RegisterService());

class RegisterState {
  final bool loading;
  final String? error;
  const RegisterState({this.loading = false, this.error});
  RegisterState copyWith({bool? loading, String? error}) =>
      RegisterState(loading: loading ?? this.loading, error: error);
}

class RegisterController extends StateNotifier<RegisterState> {
  RegisterController(this._ref) : super(const RegisterState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _ref.read(registerServiceProvider).refresh();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final registerControllerProvider = StateNotifierProvider<RegisterController, RegisterState>((ref) => RegisterController(ref));
