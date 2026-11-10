import 'package:caixinha/core/formatters.dart';
import 'package:caixinha/logic/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Mês anterior',
          onPressed: controller.previousMonth,
          icon: const Icon(Icons.chevron_left),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 180),
          child: Text(
            formatMonth(controller.month),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          tooltip: 'Próximo mês',
          onPressed: controller.nextMonth,
          icon: const Icon(Icons.chevron_right),
        ),
        TextButton(
          onPressed: controller.goToCurrentMonth,
          child: const Text('Hoje'),
        ),
      ],
    );
  }
}
