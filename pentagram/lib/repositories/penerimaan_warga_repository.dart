import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/models/penerimaan_warga.dart';
import 'package:pentagram/repositories/base_firestore_repository.dart';

class PenerimaanWargaRepository extends BaseFirestoreRepository<PenerimaanWarga> {
  PenerimaanWargaRepository(FirebaseFirestore firestore)
      : super(firestore, 'penerimaan_warga');

  @override
  PenerimaanWarga fromJson(Map<String, dynamic> json) => PenerimaanWarga.fromMap(json);

  @override
  Map<String, dynamic> toJson(PenerimaanWarga value) => value.toMap();
}
