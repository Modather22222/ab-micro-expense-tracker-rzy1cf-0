import 'package:flutter/foundation.dart';

import '../models/expense.dart';

/// In-memory, single-user expense state. All mutations notify listeners.
class ExpenseStore extends ChangeNotifier {
  ExpenseStore() {
    _seed();
  }

  final List<Expense> _expenses = <Expense>[];
  ExpenseCategory? _historyFilter;

  static int _seq = 0;
  static String _nextId() => 'e${_seq++}';

  List<Expense> get expenses => List.unmodifiable(_expenses);

  ExpenseCategory? get historyFilter => _historyFilter;

  void setFilter(ExpenseCategory? category) {
    if (_historyFilter == category) return;
    _historyFilter = category;
    notifyListeners();
  }

  List<Expense> get filteredExpenses {
    final result = _expenses
        .where((e) => _historyFilter == null || e.category == _historyFilter)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  double get total =>
      _expenses.fold(0, (sum, e) => sum + e.amount);

  Map<ExpenseCategory, double> get totalsByCategory {
    final map = <ExpenseCategory, double>{};
    for (final e in _expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  /// Daily spending totals for the trailing 7 days, oldest day first.
  List<double> get last7DaysTotals {
    final today = DateTime.now();
    final totals = List<double>.filled(7, 0);
    for (final e in _expenses) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      final diff =
          DateTime(today.year, today.month, today.day).difference(day).inDays;
      if (diff >= 0 && diff < 7) {
        totals[6 - diff] += e.amount;
      }
    }
    return totals;
  }

  void addExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
  }) {
    _expenses.add(Expense(
      id: _nextId(),
      title: title.trim().isEmpty ? category.label : title.trim(),
      amount: amount,
      category: category,
      date: DateTime.now(),
    ));
    notifyListeners();
  }

  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void _seed() {
    void seed(ExpenseCategory category, String title, double amount, int daysAgo) {
      _expenses.add(Expense(
        id: _nextId(),
        title: title,
        amount: amount,
        category: category,
        date: DateTime.now().subtract(Duration(days: daysAgo)),
      ));
    }

    seed(ExpenseCategory.food, 'Coffee & bagel', 6.40, 0);
    seed(ExpenseCategory.transport, 'Metro top-up', 20.00, 0);
    seed(ExpenseCategory.food, 'Team lunch', 18.75, 1);
    seed(ExpenseCategory.shopping, 'Phone case', 14.99, 2);
    seed(ExpenseCategory.bills, 'Mobile plan', 29.99, 3);
    seed(ExpenseCategory.fun, 'Movie night', 12.50, 3);
    seed(ExpenseCategory.food, 'Groceries', 43.20, 4);
    seed(ExpenseCategory.transport, 'Taxi home', 9.80, 5);
    seed(ExpenseCategory.other, 'Paperback book', 11.25, 6);
    seed(ExpenseCategory.fun, 'Concert ticket', 45.00, 6);
  }
}
