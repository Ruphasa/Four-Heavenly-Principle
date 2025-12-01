import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pentagram/models/transaction.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/utils/app_colors.dart';

class FinanceStatisticsPage extends ConsumerStatefulWidget {
  const FinanceStatisticsPage({super.key});

  @override
  ConsumerState<FinanceStatisticsPage> createState() => _FinanceStatisticsPageState();
}

class _FinanceStatisticsPageState extends ConsumerState<FinanceStatisticsPage> {
  String _selectedPeriod = 'Bulan Ini';

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Statistik Keuangan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Hari Ini', child: Text('Hari Ini')),
              PopupMenuItem(value: 'Minggu Ini', child: Text('Minggu Ini')),
              PopupMenuItem(value: 'Bulan Ini', child: Text('Bulan Ini')),
              PopupMenuItem(value: 'Tahun Ini', child: Text('Tahun Ini')),
            ],
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) => _buildBody(transactions),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('Gagal memuat data keuangan: $error'),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<Transaction> transactions) {
    final stats = _calculatePeriodStats(transactions);
    final chartSeries = _buildMonthlyChartSeries(transactions);
    final incomeShares = _buildCategoryShares(
      transactions.where((trx) => trx.isIncome).toList(),
    );
    final expenseShares = _buildCategoryShares(
      transactions.where((trx) => !trx.isIncome).toList(),
    );
    final recentTransactions = _getRecentTransactions(transactions);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedPeriod,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${_formatCurrency(stats.balance)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      stats.balanceChange >= 0
                          ? Icons.trending_up
                          : Icons.trending_down,
                      color: stats.balanceChange >= 0
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${stats.balanceChange.toStringAsFixed(1)}% dibanding periode sebelumnya',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Income & Expense Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Pemasukan',
                    stats.totalIncome,
                    stats.incomeChange,
                    const Color(0xFF66BB6A),
                    Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Pengeluaran',
                    stats.totalExpense,
                    stats.expenseChange,
                    const Color(0xFFEF5350),
                    Icons.arrow_upward,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Revenue Chart
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildRevenueChart(chartSeries),
          ),

          const SizedBox(height: 24),

          // Income Proportion
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildIncomeProportion(incomeShares),
          ),

          const SizedBox(height: 24),

          // Recent Transactions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildRecentTransactions(recentTransactions),
          ),

          const SizedBox(height: 24),

          // Expense by Category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildExpenseByCategory(expenseShares),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    int amount,
    double change,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: change >= 0
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      change >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: change >= 0 ? Colors.green : Colors.red,
                    ),
                    Text(
                      '${change.abs()}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: change >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rp ${_formatCurrency(amount)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(_ChartSeries series) {
    final maxValue = series.maxValue <= 0 ? 1.0 : series.maxValue * 1.2;
    final double interval =
      (maxValue / 5).clamp(1.0, double.maxFinite).toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Grafik Keuangan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '6 bulan terakhir',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey[200]!,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${(value / 1000000).toStringAsFixed(0)}jt',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.round();
                        if (index >= 0 && index < series.labels.length) {
                          return Text(
                            series.labels[index],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: maxValue,
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: series.incomeSpots,
                    isCurved: true,
                    color: const Color(0xFF66BB6A),
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF66BB6A).withOpacity(0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: series.expenseSpots,
                    isCurved: true,
                    color: const Color(0xFFEF5350),
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFEF5350).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend('Pemasukan', const Color(0xFF66BB6A)),
              const SizedBox(width: 24),
              _buildLegend('Pengeluaran', const Color(0xFFEF5350)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeProportion(List<_CategoryShare> categories) {
    if (categories.isEmpty) {
      return _buildEmptyCard('Belum ada data pemasukan.');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Proporsi Pemasukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: List.generate(categories.length, (index) {
                        final share = categories[index];
                        final color = _categoryColors[index % _categoryColors.length];
                        return PieChartSectionData(
                          value: share.amount.toDouble(),
                          title: '${share.percentage.toStringAsFixed(1)}%',
                          color: color,
                          radius: 60,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(categories.length, (index) {
                      final share = categories[index];
                      final color = _categoryColors[index % _categoryColors.length];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    share.label,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Rp ${_formatCurrency(share.amount)}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return _buildEmptyCard('Belum ada transaksi keuangan.');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaksi Terbaru',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...transactions.map(_buildTransactionItem),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isIncome = transaction.isIncome;
    final formattedDate = DateFormat('d MMM yyyy', 'id_ID').format(transaction.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isIncome
                  ? const Color(0xFF66BB6A).withOpacity(0.1)
                  : const Color(0xFFEF5350).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? const Color(0xFF66BB6A) : const Color(0xFFEF5350),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'} Rp ${_formatCurrency(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isIncome ? const Color(0xFF66BB6A) : const Color(0xFFEF5350),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseByCategory(List<_CategoryShare> categories) {
    if (categories.isEmpty) {
      return _buildEmptyCard('Belum ada data pengeluaran.');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengeluaran per Kategori',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(categories.length, (index) {
            final share = categories[index];
            final color = _categoryColors[index % _categoryColors.length];
            return _buildExpenseBar(share, color);
          }),
        ],
      ),
    );
  }

  Widget _buildExpenseBar(_CategoryShare share, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                share.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Rp ${_formatCurrency(share.amount)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: share.percentage / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.insert_chart_outlined, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  _FinanceStats _calculatePeriodStats(List<Transaction> transactions) {
    final range = _resolvePeriodRange();
    final current = transactions.where((trx) => _isWithin(trx.date, range.start, range.end)).toList();
    final previous = transactions
        .where((trx) => _isWithin(trx.date, range.previousStart, range.previousEnd))
        .toList();

    final currentIncome = _sumAmount(current.where((trx) => trx.isIncome));
    final currentExpense = _sumAmount(current.where((trx) => !trx.isIncome));
    final previousIncome = _sumAmount(previous.where((trx) => trx.isIncome));
    final previousExpense = _sumAmount(previous.where((trx) => !trx.isIncome));

    final balance = currentIncome - currentExpense;
    final previousBalance = previousIncome - previousExpense;

    return _FinanceStats(
      balance: balance,
      balanceChange: _percentageChange(balance, previousBalance),
      totalIncome: currentIncome,
      incomeChange: _percentageChange(currentIncome, previousIncome),
      totalExpense: currentExpense,
      expenseChange: _percentageChange(currentExpense, previousExpense),
    );
  }

  _ChartSeries _buildMonthlyChartSeries(List<Transaction> transactions) {
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
          .where((trx) => trx.isIncome && _isWithin(trx.date, monthStart, monthEnd))
          .fold<int>(0, (sum, trx) => sum + trx.amount);
      final expenseTotal = transactions
          .where((trx) => !trx.isIncome && _isWithin(trx.date, monthStart, monthEnd))
          .fold<int>(0, (sum, trx) => sum + trx.amount);

      maxValue = [maxValue, incomeTotal.toDouble(), expenseTotal.toDouble()].reduce((a, b) => a > b ? a : b);

      incomeSpots.add(FlSpot(index.toDouble(), incomeTotal.toDouble()));
      expenseSpots.add(FlSpot(index.toDouble(), expenseTotal.toDouble()));
    }

    return _ChartSeries(
      incomeSpots: incomeSpots,
      expenseSpots: expenseSpots,
      labels: labels,
      maxValue: maxValue,
    );
  }

  List<_CategoryShare> _buildCategoryShares(List<Transaction> transactions) {
    if (transactions.isEmpty) return [];

    final totals = <String, int>{};
    for (final trx in transactions) {
      totals[trx.title] = (totals[trx.title] ?? 0) + trx.amount;
    }

    final sum = totals.values.fold<int>(0, (value, element) => value + element);
    if (sum == 0) return [];

    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final shares = <_CategoryShare>[];
    int others = 0;
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      if (i < 4) {
        shares.add(
          _CategoryShare(
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
        _CategoryShare(
          label: 'Lainnya',
          amount: others,
          percentage: (others / sum) * 100,
        ),
      );
    }

    return shares;
  }

  List<Transaction> _getRecentTransactions(List<Transaction> transactions, {int limit = 5}) {
    final sorted = List<Transaction>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  _PeriodRange _resolvePeriodRange() {
    final now = DateTime.now();
    DateTime start;
    DateTime end;

    switch (_selectedPeriod) {
      case 'Hari Ini':
        start = DateTime(now.year, now.month, now.day);
        end = start.add(const Duration(days: 1));
        break;
      case 'Minggu Ini':
        final weekday = now.weekday;
        start = DateTime(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
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
    return _PeriodRange(start, end, previousStart, previousEnd);
  }

  bool _isWithin(DateTime date, DateTime start, DateTime end) {
    return !date.isBefore(start) && date.isBefore(end);
  }

  int _sumAmount(Iterable<Transaction> transactions) {
    return transactions.fold<int>(0, (sum, trx) => sum + trx.amount);
  }

  double _percentageChange(int current, int previous) {
    if (previous == 0) {
      return current == 0 ? 0 : 100;
    }
    final change = ((current - previous) / previous) * 100;
    return double.parse(change.toStringAsFixed(1));
  }
}

const List<Color> _categoryColors = [
  Color(0xFF42A5F5),
  Color(0xFF66BB6A),
  Color(0xFFFFB74D),
  Color(0xFFEF5350),
  Color(0xFFAB47BC),
];

class _FinanceStats {
  final int balance;
  final double balanceChange;
  final int totalIncome;
  final double incomeChange;
  final int totalExpense;
  final double expenseChange;

  const _FinanceStats({
    required this.balance,
    required this.balanceChange,
    required this.totalIncome,
    required this.incomeChange,
    required this.totalExpense,
    required this.expenseChange,
  });
}

class _ChartSeries {
  final List<FlSpot> incomeSpots;
  final List<FlSpot> expenseSpots;
  final List<String> labels;
  final double maxValue;

  const _ChartSeries({
    required this.incomeSpots,
    required this.expenseSpots,
    required this.labels,
    required this.maxValue,
  });
}

class _CategoryShare {
  final String label;
  final int amount;
  final double percentage;

  const _CategoryShare({
    required this.label,
    required this.amount,
    required this.percentage,
  });
}

class _PeriodRange {
  final DateTime start;
  final DateTime end;
  final DateTime previousStart;
  final DateTime previousEnd;

  const _PeriodRange(
    this.start,
    this.end,
    this.previousStart,
    this.previousEnd,
  );
}