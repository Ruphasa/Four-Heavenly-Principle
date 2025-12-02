import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/models/broadcast_message.dart';
import 'package:pentagram/repositories/base_firestore_repository.dart';

class BroadcastRepository extends BaseFirestoreRepository<BroadcastMessage> {
  BroadcastRepository(FirebaseFirestore firestore)
      : super(firestore, 'broadcast_messages');

  @override
  BroadcastMessage fromJson(Map<String, dynamic> json) =>
      BroadcastMessage.fromMap(json);

  @override
  Map<String, dynamic> toJson(BroadcastMessage value) => value.toMap();
}
