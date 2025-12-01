import 'package:cloud_firestore/cloud_firestore.dart';

class Citizen {
  final String? documentId;
  final String name;
  final String nik;
  final String familyRole;
  final String status;
  final String gender;
  final String maritalStatus;
  final DateTime birthDate;
  final String religion;
  final String education;
  final String occupation;
  final String familyName;

  Citizen({
    this.documentId,
    required this.name,
    required this.nik,
    required this.familyRole,
    required this.status,
    required this.gender,
    required this.maritalStatus,
    required this.birthDate,
    required this.religion,
    required this.education,
    required this.occupation,
    required this.familyName,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    final hasHadBirthday =
        now.month > birthDate.month || (now.month == birthDate.month && now.day >= birthDate.day);
    if (!hasHadBirthday) age -= 1;
    return age;
  }

  factory Citizen.fromMap(Map<String, dynamic> map) {
    final birth = map['birthDate'];
    late final DateTime birthDate;
    if (birth is Timestamp) {
      birthDate = birth.toDate();
    } else if (birth is DateTime) {
      birthDate = birth;
    } else if (birth is String) {
      birthDate = DateTime.tryParse(birth) ?? DateTime(1990);
    } else {
      birthDate = DateTime(1990);
    }

    return Citizen(
      documentId: map['_docId'] as String?,
      name: (map['name'] ?? '-') as String,
      nik: (map['nik'] ?? '-') as String,
      familyRole: (map['familyRole'] ?? '-') as String,
      status: (map['status'] ?? 'Aktif') as String,
      gender: (map['gender'] ?? 'Laki-laki') as String,
      maritalStatus: (map['maritalStatus'] ?? 'Belum Kawin') as String,
      birthDate: birthDate,
      religion: (map['religion'] ?? 'Islam') as String,
      education: (map['education'] ?? 'SMA/SMK') as String,
      occupation: (map['occupation'] ?? 'Wiraswasta') as String,
      familyName: (map['familyName'] ?? '-') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nik': nik,
      'familyRole': familyRole,
      'status': status,
      'gender': gender,
      'maritalStatus': maritalStatus,
      'birthDate': Timestamp.fromDate(birthDate),
      'religion': religion,
      'education': education,
      'occupation': occupation,
      'familyName': familyName,
    };
  }
}
