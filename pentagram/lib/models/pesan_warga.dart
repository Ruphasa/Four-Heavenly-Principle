class PesanWarga {
  final String? documentId;
  final String nama;
  final String pesan;
  final String waktu;
  final bool unread;
  final String avatar;
  final String? citizenId; // relation to citizens

  PesanWarga({
    this.documentId,
    required this.nama,
    required this.pesan,
    required this.waktu,
    required this.unread,
    required this.avatar,
    this.citizenId,
  });

  factory PesanWarga.fromMap(Map<String, dynamic> map) {
    return PesanWarga(
      documentId: map['_docId'] as String?,
      nama: map['nama'],
      pesan: map['pesan'],
      waktu: map['waktu'],
      unread: map['unread'],
      avatar: map['avatar'],
      citizenId: map['citizenId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'pesan': pesan,
      'waktu': waktu,
      'unread': unread,
      'avatar': avatar,
      'citizenId': citizenId,
    };
  }
}
