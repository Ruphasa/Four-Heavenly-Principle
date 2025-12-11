import 'package:pentagram/models/citizen.dart';
import 'package:pentagram/models/user.dart';

/// Extended model yang menggabungkan Citizen dengan User data
class CitizenWithUser {
  final Citizen citizen;
  final AppUser? user;

  const CitizenWithUser({
    required this.citizen,
    this.user,
  });

  String get name => user?.name ?? 'Unknown';
  String get documentId => citizen.documentId ?? '';
  String get userId => citizen.userId;
  String get nik => citizen.nik;
  String? get familyId => citizen.familyId;
  String? get houseId => citizen.houseId;
  String get familyRole => citizen.familyRole;
  String get status => citizen.status;
  String get gender => citizen.gender;
  String get maritalStatus => citizen.maritalStatus;
  DateTime get birthDate => citizen.birthDate;
  String get religion => citizen.religion;
  String get education => citizen.education;
  String get occupation => citizen.occupation;
  String get familyName => citizen.familyName;
  int get age => citizen.age;
}
