import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLog {
  final String? documentId;
  final int no;
  final String deskripsi;
  final String aktor;
  final DateTime tanggal;
  final String avatar;

  ActivityLog({
    this.documentId,
    required this.no,
    required this.deskripsi,
    required this.aktor,
    required this.tanggal,
    required this.avatar,
  });

  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    final rawDate = map['tanggal'];
    late final DateTime parsedDate;
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is DateTime) {
      parsedDate = rawDate;
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    final rawNo = map['no'] ?? map['index'] ?? 0;
    final intNo = rawNo is num
        ? rawNo.toInt()
        : int.tryParse(rawNo.toString()) ?? 0;

    return ActivityLog(
      documentId: map['_docId'] as String?,
      no: intNo,
      deskripsi: (map['deskripsi'] ?? '-') as String,
      aktor: (map['aktor'] ?? '-') as String,
      tanggal: parsedDate,
      avatar: (map['avatar'] ?? '--') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'deskripsi': deskripsi,
      'aktor': aktor,
      'tanggal': Timestamp.fromDate(tanggal),
      'avatar': avatar,
    };
  }
}