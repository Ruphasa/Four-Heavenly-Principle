import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/models/pesan_warga.dart';
import 'base_firestore_repository.dart';

class PesanRepository extends BaseFirestoreRepository<PesanWarga> {
  PesanRepository(FirebaseFirestore firestore) : super(firestore, 'pesan');

  @override
  PesanWarga fromJson(Map<String, dynamic> json) {
    return PesanWarga(
      nama: json['nama'] ?? '-',
      pesan: json['pesan'] ?? '',
      waktu: json['waktu'] ?? '',
      unread: (json['unread'] as bool?) ?? false,
      avatar: json['avatar'] ?? '-',
    );
  }

  @override
  Map<String, dynamic> toJson(PesanWarga value) {
    return {
      'nama': value.nama,
      'pesan': value.pesan,
      'waktu': value.waktu,
      'unread': value.unread,
      'avatar': value.avatar,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
