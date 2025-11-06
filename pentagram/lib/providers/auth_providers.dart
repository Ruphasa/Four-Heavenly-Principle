import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/auth_service.dart';

// Service provider for dependency injection
final authServiceProvider = Provider<AuthService>((ref) => const AuthService());

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthState());

  final Ref _ref;

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final ok = await _ref.read(authServiceProvider).login(
            email: email,
            password: password,
          );
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: ok,
        errorMessage: ok ? null : 'Email atau password salah',
      );
      return ok;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: 'Gagal login: $e',
      );
      return false;
    }
  }

  void logout() {
    state = const AuthState(isAuthenticated: false);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
