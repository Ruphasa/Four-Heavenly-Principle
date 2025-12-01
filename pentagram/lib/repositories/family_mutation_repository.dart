import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/models/family_mutation.dart';
import 'package:pentagram/repositories/base_firestore_repository.dart';

class FamilyMutationRepository extends BaseFirestoreRepository<FamilyMutation> {
  FamilyMutationRepository(FirebaseFirestore firestore)
      : super(firestore, 'family_mutations');

  @override
  FamilyMutation fromJson(Map<String, dynamic> json) => FamilyMutation.fromMap(json);

  @override
  Map<String, dynamic> toJson(FamilyMutation value) => value.toMap();
}
