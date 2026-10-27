import 'package:flutter_test/flutter_test.dart';

import 'package:micro_expense_tracker/main.dart';
import 'package:micro_expense_tracker/state/expense_store.dart';

void main() {
  testWidgets('renders the dashboard shell with seed data',
      (tester) async {
    await tester.pumpWidget(MicroExpenseTrackerApp(store: ExpenseStore()));
    await tester.pumpAndSettle();

    expect(find.text('Micro-Expense Tracker'), findsOneWidget);
    expect(find.text('Spent so far'), findsOneWidget);
    expect(find.text('Quick add'), findsOneWidget);
    expect(find.text('By category'), findsOneWidget);
  });
}
