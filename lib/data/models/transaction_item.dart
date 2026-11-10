import 'package:caixinha/data/models/transaction_category.dart';

class TransactionItem {
  const TransactionItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  final String id;
  final String title;
  final double amount;
  final TransactionCategory category;
  final DateTime date;

  bool get isIncome => category.type == TransactionType.income;

  double get signedAmount => isIncome ? amount : -amount;

  TransactionItem copyWith({
    String? title,
    double? amount,
    TransactionCategory? category,
    DateTime? date,
  }) {
    return TransactionItem(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category.name,
        'date': date.toIso8601String(),
      };

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: TransactionCategory.fromName(json['category'] as String?),
      date: DateTime.parse(json['date'] as String),
    );
  }
}
