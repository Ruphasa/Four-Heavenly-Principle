import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pentagram/services/storage_service.dart';

class AuthService {
  AuthService();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  final StorageService _storage = StorageService();

  /// Login using Firebase Auth email/password.
  /// If the user does not exist, this will create it (useful for first run).
  Future<bool> login({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      // Simpan state login ke shared preferences
      if (credential.user != null) {
        await _storage.saveLoginState(
          email: email,
          userId: credential.user!.uid,
        );
      }
      
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Auto-register for convenience in dev environments.
        try {
          final credential = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          
          // Simpan state login untuk user baru
          if (credential.user != null) {
            await _storage.saveLoginState(
              email: email,
              userId: credential.user!.uid,
            );
          }
          
          return true;
        } on FirebaseAuthException catch (e2) {
          // Common cases: weak-password, email-already-in-use
          throw 'Registrasi gagal: ${e2.code}';
        }
      } else if (e.code == 'wrong-password') {
        return false;
      } else {
        throw 'Login gagal: ${e.code}';
      }
    }
  }

  /// Logout user dan hapus data persistent storage
  Future<void> logout() async {
    await _auth.signOut();
    await _storage.clearLoginState();
  }

  /// Cek apakah user sudah login sebelumnya
  Future<bool> isLoggedIn() async {
    return await _storage.isLoggedIn();
  }

  /// Get current Firebase user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Get saved email from storage
  Future<String?> getSavedEmail() async {
    return await _storage.getSavedEmail();
  }
}
