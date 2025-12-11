import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/services/storage_service.dart';
import 'package:pentagram/models/user.dart';
import 'package:pentagram/providers/firestore_providers.dart';

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

/// Provider untuk mendapatkan current user data dari Firestore
final currentAppUserProvider = StreamProvider<AppUser?>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  final currentUser = FirebaseAuth.instance.currentUser;
  
  if (currentUser == null) {
    return Stream.value(null);
  }

  // Query by document ID (UID) for accurate matching
  return userRepo.streamAll(
    where: (q) => q.where(FieldPath.documentId, isEqualTo: currentUser.uid),
  ).map((users) => users.isNotEmpty ? users.first : null);
});

/// Helper untuk mendapatkan kata pertama dari nama
String getFirstName(String? fullName) {
  if (fullName == null || fullName.isEmpty) return 'User';
  return fullName.split(' ').first;
}
