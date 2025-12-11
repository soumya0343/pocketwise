enum TransactionType { income, expense }

class Transaction {
  final String id;
  final DateTime date;
  final TransactionType type;
  final String category;
  final double amount;
  final String? note;

  Transaction({
    required this.id,
    required this.date,
    required this.type,
    required this.category,
    required this.amount,
    this.note,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] ?? json['id'] ?? '',
      date: DateTime.parse(json['date']),
      type: json['type'] == 'INCOME' ? TransactionType.income : TransactionType.expense,
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'type': type == TransactionType.income ? 'INCOME' : 'EXPENSE',
      'category': category,
      'amount': amount,
      if (note != null) 'note': note,
    };
  }
}

