import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/models/citizen.dart';
import 'package:pentagram/repositories/base_firestore_repository.dart';

class CitizenRepository extends BaseFirestoreRepository<Citizen> {
  CitizenRepository(FirebaseFirestore firestore)
      : super(firestore, 'citizens');

  @override
  Citizen fromJson(Map<String, dynamic> json) => Citizen.fromMap(json);

  @override
  Map<String, dynamic> toJson(Citizen value) => value.toMap();
}
