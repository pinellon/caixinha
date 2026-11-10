import 'package:caixinha/core/app_theme.dart';
import 'package:caixinha/core/formatters.dart';
import 'package:caixinha/data/models/transaction_item.dart';
import 'package:caixinha/ui/category_style.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.item,
    this.onEdit,
    this.onDelete,
  });

  final TransactionItem item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final color = item.isIncome ? AppColors.income : AppColors.expense;
    final sign = item.isIncome ? '+' : '-';
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(item.category.icon, color: color),
      ),
      title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('${item.category.label} • ${formatDate(item.date)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$sign ${formatCurrency(item.amount)}',
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
          if (onEdit != null)
            IconButton(
              tooltip: 'Editar',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
          if (onDelete != null)
            IconButton(
              tooltip: 'Excluir',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
    );
  }
}
