import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/models/transaction.dart';
import 'package:intl/intl.dart';

class FinanceTrendChart extends StatelessWidget {
  final List<Transaction> transactions;
  final String period;

  const FinanceTrendChart({
    super.key,
    required this.transactions,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final data = _prepareChartData();
    
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
            'Tren Keuangan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.5,
            child: data.incomeSpots.isEmpty && data.expenseSpots.isEmpty
                ? const Center(child: Text('Tidak ada data'))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: data.maxY > 0 ? data.maxY / 4 : 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey[200]!,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 45,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return const Text('');
                              return Text(
                                _formatCurrency(value),
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
                              if (value.toInt() >= 0 && value.toInt() < data.labels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    data.labels[value.toInt()],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }
                              return const Text('');
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
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: (data.labels.length - 1).toDouble(),
                      minY: 0,
                      maxY: data.maxY * 1.2,
                      lineBarsData: [
                        // Income line
                        if (data.incomeSpots.isNotEmpty)
                          LineChartBarData(
                            spots: data.incomeSpots,
                            isCurved: true,
                            color: const Color(0xFF66BB6A),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(0xFF66BB6A).withOpacity(0.1),
                            ),
                          ),
                        // Expense line
                        if (data.expenseSpots.isNotEmpty)
                          LineChartBarData(
                            spots: data.expenseSpots,
                            isCurved: true,
                            color: const Color(0xFFEF5350),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(0xFFEF5350).withOpacity(0.1),
                            ),
                          ),
                      ],
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) => AppColors.primary,
                        ),
                      ),
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
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  ChartData _prepareChartData() {
    if (transactions.isEmpty) {
      return ChartData(
        incomeSpots: [],
        expenseSpots: [],
        labels: [],
        maxY: 0,
      );
    }

    Map<String, double> incomeByPeriod = {};
    Map<String, double> expenseByPeriod = {};
    
    for (final transaction in transactions) {
      String key;
      switch (period) {
        case 'Minggu Ini':
          key = DateFormat('EEE', 'id_ID').format(transaction.date);
          break;
        case 'Bulan Ini':
          key = '${transaction.date.day}';
          break;
        case 'Tahun Ini':
          key = DateFormat('MMM', 'id_ID').format(transaction.date);
          break;
        default: // Hari Ini
          key = DateFormat('HH:00').format(transaction.date);
      }

      if (transaction.isIncome) {
        incomeByPeriod[key] = (incomeByPeriod[key] ?? 0) + transaction.amount;
      } else {
        expenseByPeriod[key] = (expenseByPeriod[key] ?? 0) + transaction.amount;
      }
    }

    final allKeys = {...incomeByPeriod.keys, ...expenseByPeriod.keys}.toList()..sort();
    
    if (allKeys.isEmpty) {
      return ChartData(
        incomeSpots: [],
        expenseSpots: [],
        labels: [],
        maxY: 0,
      );
    }

    final incomeSpots = <FlSpot>[];
    final expenseSpots = <FlSpot>[];
    double maxY = 0;

    for (int i = 0; i < allKeys.length; i++) {
      final key = allKeys[i];
      final income = incomeByPeriod[key] ?? 0;
      final expense = expenseByPeriod[key] ?? 0;

      incomeSpots.add(FlSpot(i.toDouble(), income));
      expenseSpots.add(FlSpot(i.toDouble(), expense));

      maxY = [maxY, income, expense].reduce((a, b) => a > b ? a : b);
    }

    return ChartData(
      incomeSpots: incomeSpots,
      expenseSpots: expenseSpots,
      labels: allKeys,
      maxY: maxY > 0 ? maxY : 100,
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}

class ChartData {
  final List<FlSpot> incomeSpots;
  final List<FlSpot> expenseSpots;
  final List<String> labels;
  final double maxY;

  ChartData({
    required this.incomeSpots,
    required this.expenseSpots,
    required this.labels,
    required this.maxY,
  });
}
