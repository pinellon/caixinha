import 'package:caixinha/data/models/transaction_category.dart';
import 'package:flutter/material.dart';

extension TransactionCategoryStyle on TransactionCategory {
  IconData get icon => switch (this) {
        TransactionCategory.salary => Icons.work_outline,
        TransactionCategory.scholarship => Icons.school_outlined,
        TransactionCategory.extraIncome => Icons.add_card_outlined,
        TransactionCategory.food => Icons.restaurant_outlined,
        TransactionCategory.transport => Icons.directions_bus_outlined,
        TransactionCategory.education => Icons.menu_book_outlined,
        TransactionCategory.housing => Icons.home_outlined,
        TransactionCategory.leisure => Icons.sports_esports_outlined,
        TransactionCategory.health => Icons.favorite_border,
        TransactionCategory.other => Icons.category_outlined,
      };
}
