import 'package:caixinha/ui/pages/dashboard_page.dart';
import 'package:caixinha/ui/pages/rates_page.dart';
import 'package:caixinha/ui/pages/transactions_page.dart';
import 'package:caixinha/ui/widgets/transaction_form_dialog.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1000;
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _index,
                extended: wide,
                labelType:
                    wide ? NavigationRailLabelType.none : NavigationRailLabelType.all,
                onDestinationSelected: (value) => setState(() => _index = value),
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.savings_outlined,
                        size: 32,
                        color: theme.colorScheme.primary,
                      ),
                      if (wide) ...[
                        const SizedBox(width: 12),
                        Text(
                          'Caixinha',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard),
                    label: Text('Resumo'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.receipt_long_outlined),
                    selectedIcon: Icon(Icons.receipt_long),
                    label: Text('Transações'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.currency_exchange_outlined),
                    selectedIcon: Icon(Icons.currency_exchange),
                    label: Text('Câmbio'),
                  ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: IndexedStack(
                  index: _index,
                  children: const [
                    DashboardPage(),
                    TransactionsPage(),
                    RatesPage(),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: _index == 2
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => showTransactionForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Nova transação'),
                ),
        );
      },
    );
  }
}
