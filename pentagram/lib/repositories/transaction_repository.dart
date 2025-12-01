import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:pentagram/models/transaction.dart';
import 'package:pentagram/repositories/base_firestore_repository.dart';

class TransactionRepository extends BaseFirestoreRepository<Transaction> {
  TransactionRepository(FirebaseFirestore firestore)
      : super(firestore, 'transactions');

  @override
  Transaction fromJson(Map<String, dynamic> json) => Transaction.fromMap(json);

  @override
  Map<String, dynamic> toJson(Transaction value) => value.toMap();
}
