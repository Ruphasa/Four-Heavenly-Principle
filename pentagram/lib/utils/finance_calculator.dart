import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pentagram/models/transaction.dart';
import 'package:pentagram/models/finance_models.dart';

class FinanceCalculator {
  static const categoryColors = [
    Color(0xFF42A5F5),
    Color(0xFF66BB6A),
    Color(0xFFFFB74D),
    Color(0xFFEF5350),
    Color(0xFFAB47BC),
  ];

  static String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static FinanceStats calculatePeriodStats(
    List<Transaction> transactions,
    String selectedPeriod,
  ) {
    final range = resolvePeriodRange(selectedPeriod);
    final current = transactions
        .where((trx) => isWithin(trx.date, range.start, range.end))
        .toList();
    final previous = transactions
        .where((trx) => isWithin(trx.date, range.previousStart, range.previousEnd))
        .toList();

    final currentIncome = sumAmount(current.where((trx) => trx.isIncome));
    final currentExpense = sumAmount(current.where((trx) => !trx.isIncome));
    final previousIncome = sumAmount(previous.where((trx) => trx.isIncome));
    final previousExpense = sumAmount(previous.where((trx) => !trx.isIncome));

    final balance = currentIncome - currentExpense;
    final previousBalance = previousIncome - previousExpense;

    return FinanceStats(
      balance: balance,
      balanceChange: percentageChange(balance, previousBalance),
      totalIncome: currentIncome,
      incomeChange: percentageChange(currentIncome, previousIncome),
      totalExpense: currentExpense,
      expenseChange: percentageChange(currentExpense, previousExpense),
    );
  }

  static ChartSeries buildMonthlyChartSeries(List<Transaction> transactions) {
    final now = DateTime.now();
    final labels = <String>[];
    final incomeSpots = <FlSpot>[];
    final expenseSpots = <FlSpot>[];
    double maxValue = 0;

    for (int i = 5; i >= 0; i--) {
      final monthStart = DateTime(now.year, now.month - i, 1);
      final monthEnd = DateTime(monthStart.year, monthStart.month + 1, 1);
      final index = 5 - i;
      labels.add(DateFormat('MMM', 'id_ID').format(monthStart));

      final incomeTotal = transactions
          .where((trx) => trx.isIncome && isWithin(trx.date, monthStart, monthEnd))
          .fold<int>(0, (sum, trx) => sum + trx.amount);
      final expenseTotal = transactions
          .where((trx) => !trx.isIncome && isWithin(trx.date, monthStart, monthEnd))
          .fold<int>(0, (sum, trx) => sum + trx.amount);

      maxValue = [maxValue, incomeTotal.toDouble(), expenseTotal.toDouble()]
          .reduce((a, b) => a > b ? a : b);

      incomeSpots.add(FlSpot(index.toDouble(), incomeTotal.toDouble()));
      expenseSpots.add(FlSpot(index.toDouble(), expenseTotal.toDouble()));
    }

    return ChartSeries(
      incomeSpots: incomeSpots,
      expenseSpots: expenseSpots,
      labels: labels,
      maxValue: maxValue,
    );
  }

  static List<CategoryShare> buildCategoryShares(List<Transaction> transactions) {
    if (transactions.isEmpty) return [];

    final totals = <String, int>{};
    for (final trx in transactions) {
      totals[trx.title] = (totals[trx.title] ?? 0) + trx.amount;
    }

    final sum = totals.values.fold<int>(0, (value, element) => value + element);
    if (sum == 0) return [];

    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final shares = <CategoryShare>[];
    int others = 0;
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      if (i < 4) {
        shares.add(
          CategoryShare(
            label: entry.key,
            amount: entry.value,
            percentage: (entry.value / sum) * 100,
          ),
        );
      } else {
        others += entry.value;
      }
    }

    if (others > 0) {
      shares.add(
        CategoryShare(
          label: 'Lainnya',
          amount: others,
          percentage: (others / sum) * 100,
        ),
      );
    }

    return shares;
  }

  static List<Transaction> getRecentTransactions(
    List<Transaction> transactions, {
    int limit = 5,
  }) {
    final sorted = List<Transaction>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  static PeriodRange resolvePeriodRange(String selectedPeriod) {
    final now = DateTime.now();
    DateTime start;
    DateTime end;

    switch (selectedPeriod) {
      case 'Hari Ini':
        start = DateTime(now.year, now.month, now.day);
        end = start.add(const Duration(days: 1));
        break;
      case 'Minggu Ini':
        final weekday = now.weekday;
        start = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: weekday - 1));
        end = start.add(const Duration(days: 7));
        break;
      case 'Tahun Ini':
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year + 1, 1, 1);
        break;
      case 'Bulan Ini':
      default:
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 1);
        break;
    }

    final duration = end.difference(start);
    final previousEnd = start;
    final previousStart = previousEnd.subtract(duration);
    return PeriodRange(start, end, previousStart, previousEnd);
  }

  static bool isWithin(DateTime date, DateTime start, DateTime end) {
    return !date.isBefore(start) && date.isBefore(end);
  }

  static int sumAmount(Iterable<Transaction> transactions) {
    return transactions.fold<int>(0, (sum, trx) => sum + trx.amount);
  }

  static double percentageChange(int current, int previous) {
    if (previous == 0) {
      return current == 0 ? 0 : 100;
    }
    final change = ((current - previous) / previous) * 100;
    return double.parse(change.toStringAsFixed(1));
  }
}
