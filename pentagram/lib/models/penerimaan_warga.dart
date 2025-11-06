class PenerimaanWarga {
  final int no;
  final String nama;
  final String nik;
  final String email;
  final String jenisKelamin;
  final String fotoIdentitas; // asset path
  String statusRegistrasi; // Pending, Diterima, Ditolak

  PenerimaanWarga({
    required this.no,
    required this.nama,
    required this.nik,
    required this.email,
    required this.jenisKelamin,
    required this.fotoIdentitas,
    required this.statusRegistrasi,
  });

  factory PenerimaanWarga.fromMap(Map<String, dynamic> map) {
    return PenerimaanWarga(
      no: map['no'],
      nama: map['nama'],
      nik: map['nik'],
      email: map['email'],
      jenisKelamin: map['jenisKelamin'],
      fotoIdentitas: map['fotoIdentitas'],
      statusRegistrasi: map['statusRegistrasi'],
    );
  }
}
