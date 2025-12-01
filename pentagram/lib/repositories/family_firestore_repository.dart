import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/models/family.dart';
import 'package:pentagram/repositories/base_firestore_repository.dart';

class FamilyFirestoreRepository extends BaseFirestoreRepository<Family> {
  FamilyFirestoreRepository(FirebaseFirestore firestore)
      : super(firestore, 'families');

  @override
  Family fromJson(Map<String, dynamic> json) => Family.fromMap(json);

  @override
  Map<String, dynamic> toJson(Family value) => value.toMap();
}
