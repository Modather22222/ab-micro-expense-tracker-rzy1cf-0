import 'package:flutter/material.dart';

enum ExpenseCategory {
  food(Icons.fastfood, Colors.orange, 'Food'),
  transport(Icons.directions_bus, Colors.blue, 'Transport'),
  shopping(Icons.shopping_bag, Colors.purple, 'Shopping'),
  bills(Icons.receipt_long, Colors.teal, 'Bills'),
  fun(Icons.sports_esports, Colors.pink, 'Fun'),
  other(Icons.category, Colors.blueGrey, 'Other');

  const ExpenseCategory(this.icon, this.color, this.label);

  final IconData icon;
  final Color color;
  final String label;
}

class Expense {
  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
}
