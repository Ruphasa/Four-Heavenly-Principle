import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  const AuthService();

  FirebaseAuth get _auth => FirebaseAuth.instance;

  /// Login using Firebase Auth email/password.
  /// If the user does not exist, this will create it (useful for first run).
  Future<bool> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Auto-register for convenience in dev environments.
        try {
          await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
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
}
