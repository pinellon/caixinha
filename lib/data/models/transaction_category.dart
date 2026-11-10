enum TransactionType { income, expense }

enum TransactionCategory {
  salary('Salário / Estágio', TransactionType.income),
  scholarship('Bolsa', TransactionType.income),
  extraIncome('Renda extra', TransactionType.income),
  food('Alimentação', TransactionType.expense),
  transport('Transporte', TransactionType.expense),
  education('Estudos', TransactionType.expense),
  housing('Moradia', TransactionType.expense),
  leisure('Lazer', TransactionType.expense),
  health('Saúde', TransactionType.expense),
  other('Outros', TransactionType.expense);

  const TransactionCategory(this.label, this.type);

  final String label;
  final TransactionType type;

  static TransactionCategory fromName(String? name) {
    return TransactionCategory.values.firstWhere(
      (category) => category.name == name,
      orElse: () => TransactionCategory.other,
    );
  }
}
