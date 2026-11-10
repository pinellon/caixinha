import 'package:caixinha/core/app_theme.dart';
import 'package:caixinha/core/formatters.dart';
import 'package:caixinha/data/models/exchange_rate.dart';
import 'package:caixinha/logic/rates_controller.dart';
import 'package:caixinha/ui/widgets/empty_state.dart';
import 'package:caixinha/ui/widgets/status_gate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RatesPage extends StatefulWidget {
  const RatesPage({super.key});

  @override
  State<RatesPage> createState() => _RatesPageState();
}

class _RatesPageState extends State<RatesPage> {
  final _amountController = TextEditingController(text: '100,00');

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RatesController>();
    return StatusGate(
      status: controller.status,
      errorMessage: controller.errorMessage,
      onRetry: controller.load,
      builder: (context) => _buildContent(context, controller),
    );
  }

  Widget _buildContent(BuildContext context, RatesController controller) {
    final theme = Theme.of(context);
    final rates = controller.rates;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Câmbio',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: controller.load,
                icon: const Icon(Icons.refresh),
                label: const Text('Atualizar'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Cotações em reais obtidas da AwesomeAPI.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          if (rates.isEmpty)
            const Card(
              child: EmptyState(
                icon: Icons.currency_exchange,
                title: 'Sem cotações disponíveis',
                message: 'Tente atualizar em alguns instantes.',
              ),
            )
          else ...[
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final rate in rates)
                  SizedBox(width: 260, child: _RateCard(rate: rate)),
              ],
            ),
            const SizedBox(height: 24),
            _Converter(rates: rates, amountController: _amountController),
          ],
        ],
      ),
    );
  }
}

class _RateCard extends StatelessWidget {
  const _RateCard({required this.rate});

  final ExchangeRate rate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final positive = rate.pctChange >= 0;
    final color = positive ? AppColors.income : AppColors.expense;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(label: Text(rate.code)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    rate.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              formatRate(rate.bid),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  positive ? Icons.trending_up : Icons.trending_down,
                  size: 18,
                  color: color,
                ),
                const SizedBox(width: 4),
                Text(
                  formatPercent(rate.pctChange),
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (rate.updatedAt != null) ...[
              const SizedBox(height: 8),
              Text(
                'Atualizado em ${formatDateTime(rate.updatedAt!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Converter extends StatefulWidget {
  const _Converter({required this.rates, required this.amountController});

  final List<ExchangeRate> rates;
  final TextEditingController amountController;

  @override
  State<_Converter> createState() => _ConverterState();
}

class _ConverterState extends State<_Converter> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = parseAmount(widget.amountController.text);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conversor rápido',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 280,
              child: TextField(
                controller: widget.amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Valor em reais (R\$)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (amount == null || amount <= 0)
              const Text('Digite um valor válido para ver a conversão.')
            else
              Wrap(
                spacing: 24,
                runSpacing: 8,
                children: [
                  for (final rate in widget.rates.where((rate) => rate.bid > 0))
                    Text(
                      '${(amount / rate.bid).toStringAsFixed(2).replaceAll('.', ',')} ${rate.code}',
                      style: theme.textTheme.titleMedium,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
