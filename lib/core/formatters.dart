import 'package:intl/intl.dart';

final NumberFormat _currency = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: r'R$',
);

final NumberFormat _rateCurrency = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: r'R$',
  decimalDigits: 4,
);

String formatCurrency(double value) => _currency.format(value);

String formatRate(double value) => _rateCurrency.format(value);

String formatDate(DateTime date) => DateFormat('dd/MM/yyyy', 'pt_BR').format(date);

String formatDateTime(DateTime date) =>
    DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(date);

String formatMonth(DateTime date) {
  final text = DateFormat("MMMM 'de' yyyy", 'pt_BR').format(date);
  return toBeginningOfSentenceCase(text) ?? text;
}

String formatPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2).replaceAll('.', ',')}%';
}

double? parseAmount(String text) {
  var value = text.trim().replaceAll(r'R$', '').replaceAll(' ', '');
  if (value.contains(',')) {
    value = value.replaceAll('.', '').replaceAll(',', '.');
  }
  return double.tryParse(value);
}
