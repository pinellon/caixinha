import 'dart:convert';

import 'package:caixinha/data/models/transaction_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionRepository {
  static const _storageKey = 'caixinha_transactions_v1';

  Future<List<TransactionItem>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((entry) => TransactionItem.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<TransactionItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((item) => item.toJson()).toList());
    final saved = await prefs.setString(_storageKey, encoded);
    if (!saved) {
      throw Exception('Falha ao gravar os dados.');
    }
  }
}
