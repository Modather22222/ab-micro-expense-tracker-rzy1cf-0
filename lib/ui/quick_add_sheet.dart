import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../state/expense_store.dart';

/// Opens a modal bottom sheet for fast expense entry.
Future<void> showQuickAddSheet(BuildContext context, ExpenseStore store) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _QuickAddSheet(store: store),
  );
}

class _QuickAddSheet extends StatefulWidget {
  const _QuickAddSheet({required this.store});

  final ExpenseStore store;

  @override
  State<_QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<_QuickAddSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  ExpenseCategory _category = ExpenseCategory.food;
  String? _amountError;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final raw = _amountController.text.replaceAll(',', '.');
    final parsed = double.tryParse(raw);
    if (parsed == null || parsed <= 0) {
      setState(() => _amountError = 'Enter a valid amount');
      return;
    }
    widget.store.addExpense(
      title: _titleController.text,
      amount: parsed,
      category: _category,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Quick add', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title (optional)',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            autofocus: true,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixText: '\$ ',
              errorText: _amountError,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in ExpenseCategory.values)
                ChoiceChip(
                  label: Text(category.label),
                  avatar:
                      Icon(category.icon, size: 16, color: category.color),
                  selected: _category == category,
                  onSelected: (_) =>
                      setState(() => _category = category),
                ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check),
            label: const Text('Save expense'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
