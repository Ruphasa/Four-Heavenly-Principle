import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String? documentId;
  final int id;
  final String nama;
  final String kategori;
  final String penanggungJawab;
  final String? organizerUserId; // relation to users
  final DateTime tanggal;
  final String waktu;
  final String deskripsi;
  final String lokasi;
  final int peserta;

  Activity({
    this.documentId,
    required this.id,
    required this.nama,
    required this.kategori,
    required this.penanggungJawab,
    required this.tanggal,
    required this.waktu,
    required this.deskripsi,
    required this.lokasi,
    required this.peserta,
    this.organizerUserId,
  });

  // Factory constructor to create Activity from JSON/Map
  factory Activity.fromMap(Map<String, dynamic> map) {
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

    final rawId = map['id'] ?? map['activityId'] ?? 0;
    final intId = rawId is num
        ? rawId.toInt()
        : int.tryParse(rawId.toString()) ?? 0;

    return Activity(
      documentId: map['_docId'] as String?,
      id: intId,
      nama: (map['nama'] ?? map['title'] ?? '-') as String,
      kategori: (map['kategori'] ?? map['category'] ?? '-') as String,
      penanggungJawab:
          (map['penanggung_jawab'] ?? map['penanggungJawab'] ?? '-') as String,
      organizerUserId: map['organizerUserId'] as String?,
      tanggal: parsedDate,
      waktu: (map['waktu'] ?? '-') as String,
      deskripsi: (map['deskripsi'] ?? map['description'] ?? '-') as String,
      lokasi: (map['lokasi'] ?? map['location'] ?? '-') as String,
      peserta: ((map['peserta'] ?? map['participants'] ?? 0) as num).toInt(),
    );
  }

  // Convert Activity to Map (for saving to database/API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'penanggung_jawab': penanggungJawab,
      'organizerUserId': organizerUserId,
      'tanggal': Timestamp.fromDate(tanggal),
      'waktu': waktu,
      'deskripsi': deskripsi,
      'lokasi': lokasi,
      'peserta': peserta,
    };
  }

  // Copy with method for immutability
  Activity copyWith({
    String? documentId,
    int? id,
    String? nama,
    String? kategori,
    String? penanggungJawab,
    DateTime? tanggal,
    String? waktu,
    String? deskripsi,
    String? lokasi,
    int? peserta,
    String? organizerUserId,
  }) {
    return Activity(
      documentId: documentId ?? this.documentId,
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kategori: kategori ?? this.kategori,
      penanggungJawab: penanggungJawab ?? this.penanggungJawab,
      organizerUserId: organizerUserId ?? this.organizerUserId,
      tanggal: tanggal ?? this.tanggal,
      waktu: waktu ?? this.waktu,
      deskripsi: deskripsi ?? this.deskripsi,
      lokasi: lokasi ?? this.lokasi,
      peserta: peserta ?? this.peserta,
    );
  }
}