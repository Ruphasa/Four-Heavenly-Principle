class Activity {
  final int id;
  final String nama;
  final String kategori;
  final String penanggungJawab;
  final DateTime tanggal;
  final String waktu;
  final String deskripsi;
  final String lokasi;
  final int peserta;

  Activity({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.penanggungJawab,
    required this.tanggal,
    required this.waktu,
    required this.deskripsi,
    required this.lokasi,
    required this.peserta,
  });

  // Factory constructor to create Activity from JSON/Map
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as int,
      nama: map['nama'] as String,
      kategori: map['kategori'] as String,
      penanggungJawab: map['penanggung_jawab'] as String,
      tanggal: DateTime.parse(map['tanggal'] as String),
      waktu: map['waktu'] as String,
      deskripsi: map['deskripsi'] as String,
      lokasi: map['lokasi'] as String,
      peserta: map['peserta'] as int,
    );
  }

  // Convert Activity to Map (for saving to database/API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'penanggung_jawab': penanggungJawab,
      'tanggal': tanggal.toIso8601String(),
      'waktu': waktu,
      'deskripsi': deskripsi,
      'lokasi': lokasi,
      'peserta': peserta,
    };
  }

  // Copy with method for immutability
  Activity copyWith({
    int? id,
    String? nama,
    String? kategori,
    String? penanggungJawab,
    DateTime? tanggal,
    String? waktu,
    String? deskripsi,
    String? lokasi,
    int? peserta,
  }) {
    return Activity(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kategori: kategori ?? this.kategori,
      penanggungJawab: penanggungJawab ?? this.penanggungJawab,
      tanggal: tanggal ?? this.tanggal,
      waktu: waktu ?? this.waktu,
      deskripsi: deskripsi ?? this.deskripsi,
      lokasi: lokasi ?? this.lokasi,
      peserta: peserta ?? this.peserta,
    );
  }
}