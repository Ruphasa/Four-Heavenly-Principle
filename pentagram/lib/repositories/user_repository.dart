import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/models/user.dart';
import 'package:pentagram/repositories/base_firestore_repository.dart';

class UserRepository extends BaseFirestoreRepository<AppUser> {
  UserRepository(FirebaseFirestore firestore) : super(firestore, 'users');

  @override
  AppUser fromJson(Map<String, dynamic> json) => AppUser.fromMap(json);

  @override
  Map<String, dynamic> toJson(AppUser value) => value.toMap();
}
