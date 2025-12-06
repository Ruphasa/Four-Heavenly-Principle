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
import 'package:pentagram/models/broadcast_message.dart';
import 'package:pentagram/models/penerimaan_warga.dart';
import 'package:pentagram/models/user.dart';
import 'package:pentagram/models/channel.dart';
import 'package:pentagram/repositories/activity_firestore_repository.dart';
import 'package:pentagram/repositories/activity_log_firestore_repository.dart';
import 'package:pentagram/repositories/citizen_repository.dart';
import 'package:pentagram/repositories/family_firestore_repository.dart';
import 'package:pentagram/repositories/family_mutation_repository.dart';
import 'package:pentagram/repositories/house_repository.dart';
import 'package:pentagram/repositories/pesan_repository.dart';
import 'package:pentagram/repositories/transaction_repository.dart';
import 'package:pentagram/repositories/broadcast_repository.dart';
import 'package:pentagram/repositories/penerimaan_warga_repository.dart';
import 'package:pentagram/repositories/user_repository.dart';
import 'package:pentagram/repositories/channel_repository.dart';

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
  // Order by tanggal (activity date) field that exists in Activity model
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
  // Order by date field that exists in Transaction model
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

// Broadcast Messages
final broadcastRepositoryProvider = Provider<BroadcastRepository>((ref) {
  final fs = ref.watch(firestoreProvider);
  return BroadcastRepository(fs);
});

final broadcastMessagesStreamProvider =
    StreamProvider.autoDispose<List<BroadcastMessage>>((ref) {
  final repo = ref.watch(broadcastRepositoryProvider);
  return repo.streamAll(
    where: (query) => query.orderBy('sentDate', descending: true),
  );
});

// Penerimaan Warga (Citizen registration/intake)
final penerimaanWargaRepositoryProvider =
    Provider<PenerimaanWargaRepository>((ref) {
  final fs = ref.watch(firestoreProvider);
  return PenerimaanWargaRepository(fs);
});

final penerimaanWargaStreamProvider =
    StreamProvider.autoDispose<List<PenerimaanWarga>>((ref) {
  final repo = ref.watch(penerimaanWargaRepositoryProvider);
  return repo.streamAll(
    where: (q) => q.orderBy('no', descending: false),
  );
});

// Users
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final fs = ref.watch(firestoreProvider);
  return UserRepository(fs);
});

final usersStreamProvider = StreamProvider.autoDispose<List<AppUser>>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.streamAll(
    where: (q) => q.orderBy('name', descending: false),
  );
});

// Channels
final channelRepositoryProvider = Provider<ChannelRepository>((ref) {
  final fs = ref.watch(firestoreProvider);
  return ChannelRepository(fs);
});

final channelsStreamProvider =
    StreamProvider.autoDispose<List<Channel>>((ref) {
  final repo = ref.watch(channelRepositoryProvider);
  return repo.streamAll(
    where: (q) => q.orderBy('name', descending: false),
  );
});
