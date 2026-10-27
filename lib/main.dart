import 'package:flutter/material.dart';

import 'state/expense_store.dart';
import 'ui/home_screen.dart';

void main() {
  runApp(MicroExpenseTrackerApp(store: ExpenseStore()));
}

class MicroExpenseTrackerApp extends StatelessWidget {
  const MicroExpenseTrackerApp({super.key, required this.store});

  final ExpenseStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Micro-Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(store: store),
    );
  }
}
