import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String? documentId;
  final String title;
  final DateTime date;
  final int amount;
  final bool isIncome;

  Transaction({
    this.documentId,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    final rawDate = map['date'];
    late final DateTime parsedDate;
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is DateTime) {
      parsedDate = rawDate;
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return Transaction(
      documentId: map['_docId'] as String?,
      title: (map['title'] ?? '-') as String,
      date: parsedDate,
      amount: ((map['amount'] ?? 0) as num).toInt(),
      isIncome: map['isIncome'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': Timestamp.fromDate(date),
      'amount': amount,
      'isIncome': isIncome,
    };
  }

  Transaction copyWith({
    String? documentId,
    String? title,
    DateTime? date,
    int? amount,
    bool? isIncome,
  }) {
    return Transaction(
      documentId: documentId ?? this.documentId,
      title: title ?? this.title,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      isIncome: isIncome ?? this.isIncome,
    );
  }
}
