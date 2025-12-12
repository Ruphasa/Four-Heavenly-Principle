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
    // Ambil bagian sebelum @ sebagai nama, lalu format jadi kapital di awal
    return _formatNameFromEmail(email);
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

  // Query by document ID (UID) untuk matching akurat.
  // Jika terjadi error rules (misal permission-denied), kita swallow dan
  // anggap user data tidak tersedia agar UI tetap bisa jalan dengan fallback.
  return userRepo
      .streamAll(
        where: (q) => q.where(FieldPath.documentId, isEqualTo: currentUser.uid),
      )
      .handleError((_, __) {
        // Intentionally swallow Firestore errors; UI will fallback ke nama dari email.
      }).map((users) => users.isNotEmpty ? users.first : null);
});

/// Helper untuk mendapatkan kata pertama dari nama
String getFirstName(String? fullName) {
  if (fullName == null || fullName.isEmpty) return 'User';
  return fullName.split(' ').first;
}

/// Helper untuk membentuk nama tampilan dari email
String _formatNameFromEmail(String email) {
  final localPart = email.split('@').first;
  if (localPart.isEmpty) return 'User';

  // Pisah di titik/underscore jika ada, ambil bagian pertama
  final raw = localPart.split(RegExp(r'[._]')).first;
  if (raw.isEmpty) return 'User';

  final lower = raw.toLowerCase();
  return '${lower[0].toUpperCase()}${lower.substring(1)}';
}
