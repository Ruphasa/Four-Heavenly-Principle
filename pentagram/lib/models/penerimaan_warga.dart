class PenerimaanWarga {
  final int no;
  final String nama;
  final String nik;
  final String email;
  final String jenisKelamin;
  final String fotoIdentitas; // asset path
  String statusRegistrasi; // Pending, Diterima, Ditolak
  final String? applicantCitizenId; // optional relation to citizens

  PenerimaanWarga({
    required this.no,
    required this.nama,
    required this.nik,
    required this.email,
    required this.jenisKelamin,
    required this.fotoIdentitas,
    required this.statusRegistrasi,
    this.applicantCitizenId,
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
      applicantCitizenId: map['applicantCitizenId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'nama': nama,
      'nik': nik,
      'email': email,
      'jenisKelamin': jenisKelamin,
      'fotoIdentitas': fotoIdentitas,
      'statusRegistrasi': statusRegistrasi,
      'applicantCitizenId': applicantCitizenId,
    };
  }
}
