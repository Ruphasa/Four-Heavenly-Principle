import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/models/channel.dart';
import 'package:pentagram/repositories/base_firestore_repository.dart';

class ChannelRepository extends BaseFirestoreRepository<Channel> {
  ChannelRepository(FirebaseFirestore firestore) : super(firestore, 'channels');

  @override
  Channel fromJson(Map<String, dynamic> json) => Channel.fromMap(json);

  @override
  Map<String, dynamic> toJson(Channel value) => value.toMap();
}
