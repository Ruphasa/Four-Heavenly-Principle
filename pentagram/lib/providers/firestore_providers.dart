import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/repositories/pesan_repository.dart';
import 'package:pentagram/models/pesan_warga.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final pesanRepositoryProvider = Provider<PesanRepository>((ref) {
  final fs = ref.watch(firestoreProvider);
  return PesanRepository(fs);
});

final pesanStreamProvider = StreamProvider.autoDispose<List<PesanWarga>>((ref) {
  final repo = ref.watch(pesanRepositoryProvider);
  return repo.streamAll();
});
