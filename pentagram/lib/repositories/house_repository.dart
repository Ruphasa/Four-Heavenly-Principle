import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/models/house.dart';
import 'package:pentagram/repositories/base_firestore_repository.dart';

class HouseRepository extends BaseFirestoreRepository<House> {
  HouseRepository(FirebaseFirestore firestore) : super(firestore, 'houses');

  @override
  House fromJson(Map<String, dynamic> json) => House.fromMap(json);

  @override
  Map<String, dynamic> toJson(House value) => value.toMap();
}
