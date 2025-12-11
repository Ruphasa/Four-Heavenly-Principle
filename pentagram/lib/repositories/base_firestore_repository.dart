import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseFirestoreRepository<T> {
  final FirebaseFirestore firestore;
  final String collectionPath;
  static const String docIdField = '_docId';

  BaseFirestoreRepository(this.firestore, this.collectionPath);

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T value);

  CollectionReference<Map<String, dynamic>> get _col =>
      firestore.collection(collectionPath);

  CollectionReference<Map<String, dynamic>> get collection => _col;

  Stream<List<T>> streamAll({Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> q)? where}) {
    Query<Map<String, dynamic>> q = _col;
    if (where != null) q = where(q);
    return q.snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data[docIdField] = doc.id;
        return fromJson(data);
      }).toList();
    });
  }

  Future<List<T>> list() async {
    final snap = await _col.get();
    return snap.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());
      data[docIdField] = doc.id;
      return fromJson(data);
    }).toList();
  }

  Future<String> create(T value) async {
    final doc = await _col.add(toJson(value));
    return doc.id;
  }

  Future<void> set(String id, T value) async {
    await _col.doc(id).set(toJson(value));
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await _col.doc(id).update(data);
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
