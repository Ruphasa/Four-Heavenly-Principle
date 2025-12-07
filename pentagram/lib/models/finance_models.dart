import 'package:fl_chart/fl_chart.dart';

class FinanceStats {
  final int balance;
  final double balanceChange;
  final int totalIncome;
  final double incomeChange;
  final int totalExpense;
  final double expenseChange;

  const FinanceStats({
    required this.balance,
    required this.balanceChange,
    required this.totalIncome,
    required this.incomeChange,
    required this.totalExpense,
    required this.expenseChange,
  });
}

class ChartSeries {
  final List<FlSpot> incomeSpots;
  final List<FlSpot> expenseSpots;
  final List<String> labels;
  final double maxValue;

  const ChartSeries({
    required this.incomeSpots,
    required this.expenseSpots,
    required this.labels,
    required this.maxValue,
  });
}

class CategoryShare {
  final String label;
  final int amount;
  final double percentage;

  const CategoryShare({
    required this.label,
    required this.amount,
    required this.percentage,
  });
}

class PeriodRange {
  final DateTime start;
  final DateTime end;
  final DateTime previousStart;
  final DateTime previousEnd;

  const PeriodRange(
    this.start,
    this.end,
    this.previousStart,
    this.previousEnd,
  );
}
