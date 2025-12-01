import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyMutation {
  final String? documentId;
  final int no;
  final String family;
  final String type;
  final DateTime date;
  final String oldAddress;
  final String newAddress;
  final String reason;

  FamilyMutation({
    this.documentId,
    required this.no,
    required this.family,
    required this.type,
    required this.date,
    required this.oldAddress,
    required this.newAddress,
    required this.reason,
  });

  factory FamilyMutation.fromMap(Map<String, dynamic> map) {
    final rawDate = map['date'] ?? map['tanggal'];
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
    final intNo = rawNo is num ? rawNo.toInt() : int.tryParse(rawNo.toString()) ?? 0;

    return FamilyMutation(
      documentId: map['_docId'] as String?,
      no: intNo,
      family: (map['family'] ?? map['keluarga'] ?? '-') as String,
      type: (map['type'] ?? map['jenis'] ?? '-') as String,
      date: parsedDate,
      oldAddress: (map['oldAddress'] ?? map['alamatLama'] ?? '-') as String,
      newAddress: (map['newAddress'] ?? map['alamatBaru'] ?? '-') as String,
      reason: (map['reason'] ?? map['alasan'] ?? '-') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'family': family,
      'type': type,
      'date': Timestamp.fromDate(date),
      'oldAddress': oldAddress,
      'newAddress': newAddress,
      'reason': reason,
    };
  }
}
