import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/models/pesan_warga.dart';
import 'package:pentagram/repositories/base_firestore_repository.dart';

class PesanRepository extends BaseFirestoreRepository<PesanWarga> {
  PesanRepository(FirebaseFirestore firestore) : super(firestore, 'pesan');

  @override
  PesanWarga fromJson(Map<String, dynamic> json) => PesanWarga.fromMap(json);

  @override
  Map<String, dynamic> toJson(PesanWarga value) => {
        ...value.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      };
}
