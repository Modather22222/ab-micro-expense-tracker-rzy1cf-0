import 'package:flutter/material.dart';

import '../state/expense_store.dart';
import 'dashboard_tab.dart';
import 'history_tab.dart';
import 'quick_add_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store});

  final ExpenseStore store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Micro-Expense Tracker')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showQuickAddSheet(context, widget.store),
        icon: const Icon(Icons.add),
        label: const Text('Quick add'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            selectedIcon: Icon(Icons.pie_chart),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'History',
          ),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          DashboardTab(store: widget.store),
          HistoryTab(store: widget.store),
        ],
      ),
    );
  }
}
