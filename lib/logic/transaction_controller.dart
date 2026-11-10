import 'package:caixinha/data/models/transaction_category.dart';
import 'package:caixinha/data/models/transaction_item.dart';
import 'package:caixinha/data/repositories/transaction_repository.dart';
import 'package:caixinha/logic/load_status.dart';
import 'package:flutter/foundation.dart';

enum TypeFilter { all, income, expense }

class TransactionController extends ChangeNotifier {
  TransactionController(this._repository);

  final TransactionRepository _repository;

  List<TransactionItem> _items = [];
  LoadStatus _status = LoadStatus.loading;
  String? _errorMessage;
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  TypeFilter _typeFilter = TypeFilter.all;
  String _query = '';

  LoadStatus get status => _status;
  String? get errorMessage => _errorMessage;
  DateTime get month => _month;
  TypeFilter get typeFilter => _typeFilter;
  bool get hasNoData => _items.isEmpty;

  List<TransactionItem> get monthItems => _items
      .where(
        (item) => item.date.year == _month.year && item.date.month == _month.month,
      )
      .toList();

  List<TransactionItem> get filteredItems {
    final query = _query.trim().toLowerCase();
    final list = monthItems.where((item) {
      final matchesType = switch (_typeFilter) {
        TypeFilter.all => true,
        TypeFilter.income => item.isIncome,
        TypeFilter.expense => !item.isIncome,
      };
      final matchesQuery = query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.category.label.toLowerCase().contains(query);
      return matchesType && matchesQuery;
    }).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  List<TransactionItem> get recentItems {
    final list = monthItems..sort((a, b) => b.date.compareTo(a.date));
    return list.take(5).toList();
  }

  double get totalIncome => monthItems
      .where((item) => item.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense => monthItems
      .where((item) => !item.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get balance => totalIncome - totalExpense;

  List<MapEntry<TransactionCategory, double>> get expensesByCategory {
    final totals = <TransactionCategory, double>{};
    for (final item in monthItems.where((item) => !item.isIncome)) {
      totals.update(
        item.category,
        (value) => value + item.amount,
        ifAbsent: () => item.amount,
      );
    }
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  Future<void> load() async {
    if (_status != LoadStatus.loading) {
      _status = LoadStatus.loading;
      notifyListeners();
    }
    try {
      _items = await _repository.load();
      _errorMessage = null;
      _status = LoadStatus.ready;
    } catch (_) {
      _errorMessage = 'Não foi possível carregar suas transações.';
      _status = LoadStatus.error;
    }
    notifyListeners();
  }

  Future<bool> add(TransactionItem item) async {
    _items = [..._items, item];
    _month = DateTime(item.date.year, item.date.month);
    notifyListeners();
    return _persist();
  }

  Future<bool> update(TransactionItem item) async {
    _items = [
      for (final current in _items) current.id == item.id ? item : current,
    ];
    _month = DateTime(item.date.year, item.date.month);
    notifyListeners();
    return _persist();
  }

  Future<bool> remove(String id) async {
    _items = _items.where((item) => item.id != id).toList();
    notifyListeners();
    return _persist();
  }

  Future<bool> loadSamples() async {
    final now = DateTime.now();
    TransactionItem sample(
      int day,
      String title,
      double amount,
      TransactionCategory category,
    ) {
      return TransactionItem(
        id: '${now.microsecondsSinceEpoch}-$day-${category.name}',
        title: title,
        amount: amount,
        category: category,
        date: DateTime(now.year, now.month, day),
      );
    }

    _items = [
      ..._items,
      sample(2, 'Estágio', 1800, TransactionCategory.salary),
      sample(3, 'Aluguel da república', 650, TransactionCategory.housing),
      sample(5, 'Mercado do mês', 320.9, TransactionCategory.food),
      sample(7, 'Apostilas e livros', 145, TransactionCategory.education),
      sample(9, 'Passe do ônibus', 220, TransactionCategory.transport),
      sample(12, 'Cinema com amigos', 58, TransactionCategory.leisure),
      sample(15, 'Freela de design', 400, TransactionCategory.extraIncome),
      sample(18, 'Farmácia', 47.5, TransactionCategory.health),
    ];
    _month = DateTime(now.year, now.month);
    notifyListeners();
    return _persist();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setTypeFilter(TypeFilter value) {
    _typeFilter = value;
    notifyListeners();
  }

  void previousMonth() {
    _month = DateTime(_month.year, _month.month - 1);
    notifyListeners();
  }

  void nextMonth() {
    _month = DateTime(_month.year, _month.month + 1);
    notifyListeners();
  }

  void goToCurrentMonth() {
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    notifyListeners();
  }

  Future<bool> _persist() async {
    try {
      await _repository.save(_items);
      return true;
    } catch (_) {
      return false;
    }
  }
}
