import 'package:caixinha/core/formatters.dart';
import 'package:caixinha/data/models/transaction_category.dart';
import 'package:caixinha/data/models/transaction_item.dart';
import 'package:caixinha/logic/transaction_controller.dart';
import 'package:caixinha/ui/category_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showTransactionForm(
  BuildContext context, {
  TransactionItem? existing,
}) async {
  final controller = context.read<TransactionController>();
  final messenger = ScaffoldMessenger.of(context);
  final result = await showDialog<TransactionItem>(
    context: context,
    builder: (_) => TransactionFormDialog(existing: existing),
  );
  if (result == null) {
    return;
  }
  final saved = existing == null
      ? await controller.add(result)
      : await controller.update(result);
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        saved
            ? 'Transação salva com sucesso.'
            : 'Não foi possível gravar os dados no disco.',
      ),
    ),
  );
}

class TransactionFormDialog extends StatefulWidget {
  const TransactionFormDialog({super.key, this.existing});

  final TransactionItem? existing;

  @override
  State<TransactionFormDialog> createState() => _TransactionFormDialogState();
}

class _TransactionFormDialogState extends State<TransactionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late TransactionCategory _category;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _amountController = TextEditingController(
      text: existing == null
          ? ''
          : existing.amount.toStringAsFixed(2).replaceAll('.', ','),
    );
    _category = existing?.category ?? TransactionCategory.food;
    _date = existing?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => _date = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = parseAmount(_amountController.text)!;
    Navigator.of(context).pop(
      TransactionItem(
        id: widget.existing?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        amount: amount,
        category: _category,
        date: _date,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return AlertDialog(
      title: Text(isEditing ? 'Editar transação' : 'Nova transação'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Informe um título'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Valor (R\$)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final amount = parseAmount(value ?? '');
                    if (amount == null || amount <= 0) {
                      return 'Informe um valor maior que zero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TransactionCategory>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final category in TransactionCategory.values)
                      DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Icon(category.icon, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              '${category.label} '
                              '(${category.type == TransactionType.income ? 'receita' : 'despesa'})',
                            ),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _category = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Data',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(formatDate(_date)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Salvar')),
      ],
    );
  }
}
