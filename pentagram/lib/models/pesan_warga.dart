class PesanWarga {
  final String nama;
  final String pesan;
  final String waktu;
  final bool unread;
  final String avatar;

  PesanWarga({
    required this.nama,
    required this.pesan,
    required this.waktu,
    required this.unread,
    required this.avatar,
  });

  factory PesanWarga.fromMap(Map<String, dynamic> map) {
    return PesanWarga(
      nama: map['nama'],
      pesan: map['pesan'],
      waktu: map['waktu'],
      unread: map['unread'],
      avatar: map['avatar'],
    );
  }
}
