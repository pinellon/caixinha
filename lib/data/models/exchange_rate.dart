class ExchangeRate {
  const ExchangeRate({
    required this.code,
    required this.name,
    required this.bid,
    required this.pctChange,
    this.updatedAt,
  });

  final String code;
  final String name;
  final double bid;
  final double pctChange;
  final DateTime? updatedAt;

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    final fullName = (json['name'] as String?) ?? '';
    return ExchangeRate(
      code: (json['code'] as String?) ?? '',
      name: fullName.split('/').first,
      bid: double.tryParse('${json['bid']}') ?? 0,
      pctChange: double.tryParse('${json['pctChange']}') ?? 0,
      updatedAt: DateTime.tryParse('${json['create_date']}'),
    );
  }
}
