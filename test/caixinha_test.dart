import 'package:caixinha/data/models/transaction_category.dart';
import 'package:caixinha/data/models/transaction_item.dart';
import 'package:caixinha/data/repositories/transaction_repository.dart';
import 'package:caixinha/logic/transaction_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRepository extends TransactionRepository {
  List<TransactionItem> stored = [];
  bool failOnSave = false;

  @override
  Future<List<TransactionItem>> load() async => List.of(stored);

  @override
  Future<void> save(List<TransactionItem> items) async {
    if (failOnSave) {
      throw Exception('falha');
    }
    stored = List.of(items);
  }
}

TransactionItem buildItem(String id, double amount, TransactionCategory category) {
  return TransactionItem(
    id: id,
    title: 'Item $id',
    amount: amount,
    category: category,
    date: DateTime.now(),
  );
}

void main() {
  test('serializa e desserializa uma transação', () {
    final item = buildItem('1', 99.9, TransactionCategory.food);
    final restored = TransactionItem.fromJson(item.toJson());
    expect(restored.id, item.id);
    expect(restored.amount, item.amount);
    expect(restored.category, item.category);
    expect(restored.date, item.date);
  });

  test('calcula receitas, despesas e saldo do mês', () async {
    final controller = TransactionController(FakeRepository());
    await controller.load();
    await controller.add(buildItem('1', 1000, TransactionCategory.salary));
    await controller.add(buildItem('2', 250, TransactionCategory.food));
    expect(controller.totalIncome, 1000);
    expect(controller.totalExpense, 250);
    expect(controller.balance, 750);
  });

  test('remove uma transação e persiste a lista', () async {
    final repository = FakeRepository();
    final controller = TransactionController(repository);
    await controller.load();
    await controller.add(buildItem('1', 100, TransactionCategory.leisure));
    await controller.remove('1');
    expect(controller.monthItems, isEmpty);
    expect(repository.stored, isEmpty);
  });

  test('informa falha quando não consegue gravar', () async {
    final repository = FakeRepository()..failOnSave = true;
    final controller = TransactionController(repository);
    await controller.load();
    final saved = await controller.add(
      buildItem('1', 100, TransactionCategory.leisure),
    );
    expect(saved, isFalse);
  });
}
