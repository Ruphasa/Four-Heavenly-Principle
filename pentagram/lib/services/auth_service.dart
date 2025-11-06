import 'dart:async';

class AuthService {
  const AuthService();

  Future<bool> login({required String email, required String password}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));
    // Replace with real API call
    return email == 'admin@gmail.com' && password == 'password';
  }
}
