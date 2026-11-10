import 'dart:convert';

import 'package:caixinha/data/models/exchange_rate.dart';
import 'package:http/http.dart' as http;

class RatesException implements Exception {
  const RatesException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RatesService {
  RatesService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static final Uri _endpoint = Uri.parse(
    'https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL,GBP-BRL',
  );

  Future<List<ExchangeRate>> fetchRates() async {
    final response = await _client
        .get(_endpoint)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw RatesException(
        'Serviço de cotações indisponível (${response.statusCode}).',
      );
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data.values
        .map((entry) => ExchangeRate.fromJson(entry as Map<String, dynamic>))
        .toList();
  }
}
