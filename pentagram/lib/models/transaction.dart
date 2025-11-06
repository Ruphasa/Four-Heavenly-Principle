class Transaction {
  final String title;
  final DateTime date;
  final int amount;
  final bool isIncome;

  Transaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      title: map['title'] as String,
      date: map['date'] as DateTime,
      amount: map['amount'] as int,
      isIncome: map['isIncome'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'amount': amount,
      'isIncome': isIncome,
    };
  }
}
