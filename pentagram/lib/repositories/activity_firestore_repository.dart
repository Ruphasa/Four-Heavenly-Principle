import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/models/activity.dart';
import 'package:pentagram/repositories/base_firestore_repository.dart';

class ActivityFirestoreRepository extends BaseFirestoreRepository<Activity> {
  ActivityFirestoreRepository(FirebaseFirestore firestore)
      : super(firestore, 'activities');

  @override
  Activity fromJson(Map<String, dynamic> json) => Activity.fromMap(json);

  @override
  Map<String, dynamic> toJson(Activity value) => value.toMap();
}
