import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../state/expense_store.dart';
import '../util/format.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key, required this.store});

  final ExpenseStore store;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final expenses = store.filteredExpenses;

        return Column(
          children: [
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('All'),
                      selected: store.historyFilter == null,
                      onSelected: (_) => store.setFilter(null),
                    ),
                  ),
                  for (final category in ExpenseCategory.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category.label),
                        selected: store.historyFilter == category,
                        onSelected: (_) => store.setFilter(category),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: expenses.isEmpty
                  ? const _EmptyHistory()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return Dismissible(
                          key: ValueKey(expense.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete,
                                color: Colors.white),
                          ),
                          onDismissed: (_) =>
                              store.deleteExpense(expense.id),
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: expense
                                    .category.color
                                    .withValues(alpha: 0.15),
                                foregroundColor: expense.category.color,
                                child: Icon(expense.category.icon,
                                    size: 20),
                              ),
                              title: Text(expense.title),
                              subtitle: Text(
                                  '${expense.category.label} · ${formatDay(expense.date)}'),
                              trailing: Text(
                                formatAmount(expense.amount),
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long,
              size: 48, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 8),
          const Text('No expenses match this filter'),
        ],
      ),
    );
  }
}
