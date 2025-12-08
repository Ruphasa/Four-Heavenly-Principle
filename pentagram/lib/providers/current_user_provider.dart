import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pentagram/services/storage_service.dart';

/// Provider untuk mendapatkan current user ID dari Firebase Auth
final currentUserIdProvider = FutureProvider<String?>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  }

  // Fallback ke SharedPreferences jika tidak ada Firebase user
  final storage = StorageService();
  return await storage.getSavedUserId();
});

/// Provider untuk mendapatkan current user email
final currentUserEmailProvider = FutureProvider<String?>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.email;
  }

  // Fallback ke SharedPreferences
  final storage = StorageService();
  return await storage.getSavedEmail();
});

/// Provider untuk mendapatkan current user display name
final currentUserNameProvider = FutureProvider<String>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null &&
      user.displayName != null &&
      user.displayName!.isNotEmpty) {
    return user.displayName!;
  }

  // Fallback ke email sebagai nama
  final email = await ref.watch(currentUserEmailProvider.future);
  if (email != null) {
    // Ambil bagian sebelum @ sebagai nama
    return email.split('@').first.toUpperCase();
  }

  return 'User';
});

/// Stream provider untuk current Firebase user
final currentFirebaseUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
