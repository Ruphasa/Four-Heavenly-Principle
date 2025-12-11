import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/register_service.dart';

final registerServiceProvider = Provider<RegisterService>((ref) => RegisterService());

class RegisterState {
  final bool loading;
  final String? error;
  final bool success;
  
  const RegisterState({
    this.loading = false,
    this.error,
    this.success = false,
  });
  
  RegisterState copyWith({
    bool? loading,
    String? error,
    bool? success,
  }) => RegisterState(
    loading: loading ?? this.loading,
    error: error,
    success: success ?? this.success,
  );
}

class RegisterController extends StateNotifier<RegisterState> {
  RegisterController(this._ref) : super(const RegisterState());
  final Ref _ref;
  
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String nik,
    required String phone,
    required String birthPlace,
    required String birthDate,
    required String gender,
    required String address,
    String? selectedHouseAddress,
    required String ownershipStatus,
  }) async {
    state = state.copyWith(loading: true, error: null, success: false);
    try {
      await _ref.read(registerServiceProvider).registerUser(
        email: email,
        password: password,
        name: name,
        nik: nik,
        phone: phone,
        birthPlace: birthPlace,
        birthDate: birthDate,
        gender: gender,
        address: address,
        selectedHouseAddress: selectedHouseAddress,
        ownershipStatus: ownershipStatus,
      );
      state = state.copyWith(loading: false, success: true);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString(), success: false);
    }
  }
  
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
