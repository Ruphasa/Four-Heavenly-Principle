import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/models/activity_log.dart';
import 'package:pentagram/repositories/base_firestore_repository.dart';

class ActivityLogFirestoreRepository extends BaseFirestoreRepository<ActivityLog> {
  ActivityLogFirestoreRepository(FirebaseFirestore firestore)
      : super(firestore, 'activity_logs');

  @override
  ActivityLog fromJson(Map<String, dynamic> json) => ActivityLog.fromMap(json);

  @override
  Map<String, dynamic> toJson(ActivityLog value) => value.toMap();
}
