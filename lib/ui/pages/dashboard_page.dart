import 'package:caixinha/core/app_theme.dart';
import 'package:caixinha/core/formatters.dart';
import 'package:caixinha/data/models/transaction_category.dart';
import 'package:caixinha/data/models/transaction_item.dart';
import 'package:caixinha/logic/transaction_controller.dart';
import 'package:caixinha/ui/category_style.dart';
import 'package:caixinha/ui/widgets/empty_state.dart';
import 'package:caixinha/ui/widgets/month_selector.dart';
import 'package:caixinha/ui/widgets/status_gate.dart';
import 'package:caixinha/ui/widgets/summary_card.dart';
import 'package:caixinha/ui/widgets/transaction_form_dialog.dart';
import 'package:caixinha/ui/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();
    return StatusGate(
      status: controller.status,
      errorMessage: controller.errorMessage,
      onRetry: controller.load,
      builder: (context) => _DashboardContent(controller: controller),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.controller});

  final TransactionController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final balanceColor =
        controller.balance >= 0 ? AppColors.brand : AppColors.expense;
    final cards = [
      SummaryCard(
        label: 'Saldo do mês',
        value: controller.balance,
        icon: Icons.account_balance_wallet_outlined,
        color: balanceColor,
      ),
      SummaryCard(
        label: 'Receitas',
        value: controller.totalIncome,
        icon: Icons.arrow_downward,
        color: AppColors.income,
      ),
      SummaryCard(
        label: 'Despesas',
        value: controller.totalExpense,
        icon: Icons.arrow_upward,
        color: AppColors.expense,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo financeiro',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const MonthSelector(),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 720) {
                return Row(
                  children: [
                    for (var i = 0; i < cards.length; i++) ...[
                      if (i > 0) const SizedBox(width: 16),
                      Expanded(child: cards[i]),
                    ],
                  ],
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(height: 12),
                    cards[i],
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          if (controller.monthItems.isEmpty)
            Card(
              child: EmptyState(
                icon: Icons.inbox_outlined,
                title: 'Nenhuma transação neste mês',
                message:
                    'Registre suas receitas e despesas para acompanhar para onde vai o seu dinheiro.',
                actions: [
                  FilledButton.icon(
                    onPressed: () => showTransactionForm(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar transação'),
                  ),
                  if (controller.hasNoData)
                    OutlinedButton.icon(
                      onPressed: controller.loadSamples,
                      icon: const Icon(Icons.auto_awesome_outlined),
                      label: const Text('Carregar dados de exemplo'),
                    ),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final categoryPanel = _CategoryPanel(
                  totals: controller.expensesByCategory,
                  totalExpense: controller.totalExpense,
                );
                final recentPanel = _RecentPanel(items: controller.recentItems);
                if (constraints.maxWidth >= 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: categoryPanel),
                      const SizedBox(width: 16),
                      Expanded(child: recentPanel),
                    ],
                  );
                }
                return Column(
                  children: [
                    categoryPanel,
                    const SizedBox(height: 16),
                    recentPanel,
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class _CategoryPanel extends StatelessWidget {
  const _CategoryPanel({required this.totals, required this.totalExpense});

  final List<MapEntry<TransactionCategory, double>> totals;
  final double totalExpense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Despesas por categoria',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            if (totals.isEmpty)
              const Text('Nenhuma despesa registrada neste mês.')
            else
              for (final entry in totals)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(entry.key.icon, size: 20),
                          const SizedBox(width: 8),
                          Expanded(child: Text(entry.key.label)),
                          Text(formatCurrency(entry.value)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: totalExpense > 0 ? entry.value / totalExpense : 0,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _RecentPanel extends StatelessWidget {
  const _RecentPanel({required this.items});

  final List<TransactionItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              'Últimas transações',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (final item in items) TransactionTile(item: item),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
