import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/models/chat_message.dart';

class ChatMessageRepository {
  final FirebaseFirestore _firestore;
  final String collectionName = 'group_chat_messages';

  ChatMessageRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionName);

  Stream<List<ChatMessage>> streamAll() {
    return _collection
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ChatMessage.fromMap({...doc.data(), '_docId': doc.id}),
              )
              .toList(),
        );
  }

  Future<List<ChatMessage>> getAll() async {
    final snapshot = await _collection
        .orderBy('timestamp', descending: false)
        .get();
    return snapshot.docs
        .map((doc) => ChatMessage.fromMap({...doc.data(), '_docId': doc.id}))
        .toList();
  }

  Future<ChatMessage?> getById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return ChatMessage.fromMap({...doc.data()!, '_docId': doc.id});
  }

  Future<void> create(ChatMessage message) async {
    await _collection.add(message.toMap());
  }

  Future<void> update(String id, ChatMessage message) async {
    await _collection.doc(id).update(message.toMap());
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
