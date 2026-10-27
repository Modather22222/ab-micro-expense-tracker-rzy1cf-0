import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../state/expense_store.dart';
import '../util/format.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key, required this.store});

  final ExpenseStore store;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final theme = Theme.of(context);
        final byCategory = store.totalsByCategory;
        final total = store.total;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Spent so far', style: theme.textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(
                      formatAmount(total),
                      style: theme.textTheme.displaySmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${store.expenses.length} expenses logged',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('By category', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (byCategory.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No spending yet — tap Quick add.')),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 48,
                            sections: [
                              for (final entry in byCategory.entries)
                                PieChartSectionData(
                                  value: entry.value,
                                  color: entry.key.color,
                                  radius: 44,
                                  title:
                                      '${((entry.value / total) * 100).round()}%',
                                  titleStyle: theme.textTheme.labelSmall
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...[
                        for (final entry in byCategory.entries)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(entry.key.icon,
                                    size: 18, color: entry.key.color),
                                const SizedBox(width: 8),
                                Expanded(child: Text(entry.key.label)),
                                Text(formatAmount(entry.value)),
                              ],
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text('Last 7 days', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 160,
                  child: _WeekChart(totals: store.last7DaysTotals),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WeekChart extends StatelessWidget {
  const _WeekChart({required this.totals});

  final List<double> totals;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final labels = [
      for (var i = 0; i < 7; i++)
        ['M', 'T', 'W', 'T', 'F', 'S', 'S'][
            DateTime.now().subtract(Duration(days: 6 - i)).weekday - 1],
    ];
    var maxY = 10.0;
    for (final value in totals) {
      if (value > maxY) maxY = value;
    }

    return BarChart(
      BarChartData(
        maxY: maxY * 1.2,
        alignment: BarChartAlignment.spaceAround,
        barTouchData: const BarTouchData(enabled: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          leftTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= labels.length) {
                  return const SizedBox.shrink();
                }
                return Text(labels[index],
                    style: Theme.of(context).textTheme.labelSmall);
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < totals.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: totals[i],
                  color: scheme.primary,
                  width: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
