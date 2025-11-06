class ActivityLog {
  final int no;
  final String deskripsi;
  final String aktor;
  final DateTime tanggal;
  final String avatar;

  ActivityLog({
    required this.no,
    required this.deskripsi,
    required this.aktor,
    required this.tanggal,
    required this.avatar,
  });

  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      no: map['no'] as int,
      deskripsi: map['deskripsi'] as String,
      aktor: map['aktor'] as String,
      tanggal: DateTime.parse(map['tanggal'] as String),
      avatar: map['avatar'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'deskripsi': deskripsi,
      'aktor': aktor,
      'tanggal': tanggal.toIso8601String(),
      'avatar': avatar,
    };
  }
}