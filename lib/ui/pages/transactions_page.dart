import 'package:caixinha/data/models/transaction_item.dart';
import 'package:caixinha/logic/transaction_controller.dart';
import 'package:caixinha/ui/widgets/empty_state.dart';
import 'package:caixinha/ui/widgets/month_selector.dart';
import 'package:caixinha/ui/widgets/status_gate.dart';
import 'package:caixinha/ui/widgets/transaction_form_dialog.dart';
import 'package:caixinha/ui/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();
    return StatusGate(
      status: controller.status,
      errorMessage: controller.errorMessage,
      onRetry: controller.load,
      builder: (context) => _TransactionsContent(controller: controller),
    );
  }
}

class _TransactionsContent extends StatelessWidget {
  const _TransactionsContent({required this.controller});

  final TransactionController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = controller.filteredItems;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transações',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const MonthSelector(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: controller.setQuery,
                  decoration: const InputDecoration(
                    hintText: 'Buscar por título ou categoria',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SegmentedButton<TypeFilter>(
                segments: const [
                  ButtonSegment(value: TypeFilter.all, label: Text('Todas')),
                  ButtonSegment(
                    value: TypeFilter.income,
                    label: Text('Receitas'),
                  ),
                  ButtonSegment(
                    value: TypeFilter.expense,
                    label: Text('Despesas'),
                  ),
                ],
                selected: {controller.typeFilter},
                onSelectionChanged: (selection) =>
                    controller.setTypeFilter(selection.first),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: items.isEmpty
                ? Card(
                    child: EmptyState(
                      icon: Icons.search_off,
                      title: 'Nada por aqui',
                      message:
                          'Nenhuma transação encontrada para este mês e filtros. Que tal registrar uma nova?',
                      actions: [
                        FilledButton.icon(
                          onPressed: () => showTransactionForm(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Nova transação'),
                        ),
                      ],
                    ),
                  )
                : Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return TransactionTile(
                          item: item,
                          onEdit: () =>
                              showTransactionForm(context, existing: item),
                          onDelete: () => _confirmDelete(context, item),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

Future<void> _confirmDelete(BuildContext context, TransactionItem item) async {
  final controller = context.read<TransactionController>();
  final messenger = ScaffoldMessenger.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Excluir transação'),
      content: Text('Deseja realmente excluir "${item.title}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Excluir'),
        ),
      ],
    ),
  );
  if (confirmed != true) {
    return;
  }
  final saved = await controller.remove(item.id);
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        saved
            ? 'Transação excluída.'
            : 'Não foi possível gravar os dados no disco.',
      ),
    ),
  );
}
