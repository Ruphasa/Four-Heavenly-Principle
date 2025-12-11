import 'package:cloud_firestore/cloud_firestore.dart';

class Citizen {
  final String? documentId;
  final String userId; // Reference to users collection (Firebase Auth UID)
  final String nik;
  final String? familyId; // relation to families
  final String? houseId; // relation to houses
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
    required this.userId,
    required this.nik,
    this.familyId,
    this.houseId,
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

  /// Helper to get citizen name from userId
  /// This should be used with a FutureBuilder or StreamBuilder to fetch user data
  static Future<String> getNameFromUserId(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        return (userDoc.data()?['name'] as String?) ?? 'Unknown';
      }
      return 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
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
      userId: (map['userId'] ?? '-') as String,
      nik: (map['nik'] ?? '-') as String,
      familyId: map['familyId'] as String?,
      houseId: map['houseId'] as String?,
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
      'userId': userId,
      'nik': nik,
      'familyId': familyId,
      'houseId': houseId,
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
