import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:pentagram/models/activity.dart';
import 'package:pentagram/models/activity_log.dart';
import 'package:pentagram/models/citizen.dart';
import 'package:pentagram/models/family.dart';
import 'package:pentagram/models/family_mutation.dart';
import 'package:pentagram/models/house.dart';
import 'package:pentagram/models/pesan_warga.dart';
import 'package:pentagram/models/transaction.dart';
import 'package:pentagram/repositories/activity_firestore_repository.dart';
import 'package:pentagram/repositories/activity_log_firestore_repository.dart';
import 'package:pentagram/repositories/citizen_repository.dart';
import 'package:pentagram/repositories/family_firestore_repository.dart';
import 'package:pentagram/repositories/family_mutation_repository.dart';
import 'package:pentagram/repositories/house_repository.dart';
import 'package:pentagram/repositories/pesan_repository.dart';
import 'package:pentagram/repositories/transaction_repository.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Pesan
final pesanRepositoryProvider = Provider<PesanRepository>((ref) {
  final fs = ref.watch(firestoreProvider);
  return PesanRepository(fs);
});

final pesanStreamProvider = StreamProvider.autoDispose<List<PesanWarga>>((ref) {
  final repo = ref.watch(pesanRepositoryProvider);
  return repo.streamAll();
});

// Activities
final activityRepositoryProvider = Provider<ActivityFirestoreRepository>((ref) {
  final fs = ref.watch(firestoreProvider);
  return ActivityFirestoreRepository(fs);
});

final activitiesStreamProvider =
    StreamProvider.autoDispose<List<Activity>>((ref) {
  final repo = ref.watch(activityRepositoryProvider);
  return repo.streamAll(
    where: (query) => query.orderBy('tanggal', descending: false),
  );
});

// Activity logs
final activityLogRepositoryProvider =
    Provider<ActivityLogFirestoreRepository>((ref) {
  final fs = ref.watch(firestoreProvider);
  return ActivityLogFirestoreRepository(fs);
});

final activityLogsStreamProvider =
    StreamProvider.autoDispose<List<ActivityLog>>((ref) {
  final repo = ref.watch(activityLogRepositoryProvider);
  return repo.streamAll(
    where: (query) => query.orderBy('tanggal', descending: true),
  );
});

// Transactions
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final fs = ref.watch(firestoreProvider);
  return TransactionRepository(fs);
});

final transactionsStreamProvider =
    StreamProvider.autoDispose<List<Transaction>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.streamAll(
    where: (query) => query.orderBy('date', descending: true),
  );
});

// Population data
final citizenRepositoryProvider = Provider<CitizenRepository>((ref) {
  final fs = ref.watch(firestoreProvider);
  return CitizenRepository(fs);
});

final citizensStreamProvider = StreamProvider.autoDispose<List<Citizen>>((ref) {
  final repo = ref.watch(citizenRepositoryProvider);
  return repo.streamAll();
});

final familyRepositoryProvider = Provider<FamilyFirestoreRepository>((ref) {
  final fs = ref.watch(firestoreProvider);
  return FamilyFirestoreRepository(fs);
});

final familiesStreamProvider = StreamProvider.autoDispose<List<Family>>((ref) {
  final repo = ref.watch(familyRepositoryProvider);
  return repo.streamAll();
});

final houseRepositoryProvider = Provider<HouseRepository>((ref) {
  final fs = ref.watch(firestoreProvider);
  return HouseRepository(fs);
});

final housesStreamProvider = StreamProvider.autoDispose<List<House>>((ref) {
  final repo = ref.watch(houseRepositoryProvider);
  return repo.streamAll();
});

final familyMutationRepositoryProvider =
    Provider<FamilyMutationRepository>((ref) {
  final fs = ref.watch(firestoreProvider);
  return FamilyMutationRepository(fs);
});

final familyMutationsStreamProvider =
    StreamProvider.autoDispose<List<FamilyMutation>>((ref) {
  final repo = ref.watch(familyMutationRepositoryProvider);
  return repo.streamAll(
    where: (query) => query.orderBy('date', descending: true),
  );
});
