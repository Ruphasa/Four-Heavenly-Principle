import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/models/activity.dart';
import 'package:intl/intl.dart';

class ActivityTimelineChart extends StatelessWidget {
  final List<Activity> activities;

  const ActivityTimelineChart({
    super.key,
    required this.activities,
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
            'Aktivitas per Bulan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.7,
            child: data.isEmpty
                ? const Center(child: Text('Tidak ada data'))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: data.values.reduce((a, b) => a > b ? a : b) * 1.2,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) => AppColors.primary,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final month = data.keys.elementAt(groupIndex);
                            return BarTooltipItem(
                              '$month\n${rod.toY.toInt()} kegiatan',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return const Text('');
                              return Text(
                                value.toInt().toString(),
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
                              if (value.toInt() < 0 || value.toInt() >= data.length) {
                                return const Text('');
                              }
                              final month = data.keys.elementAt(value.toInt());
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  month,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 10,
                                  ),
                                ),
                              );
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
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 2,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey[200]!,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: data.entries.map((entry) {
                        final index = data.keys.toList().indexOf(entry.key);
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.toDouble(),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  const Color(0xFF42A5F5).withOpacity(0.7),
                                  const Color(0xFF42A5F5),
                                ],
                              ),
                              width: 24,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _prepareChartData() {
    if (activities.isEmpty) return {};

    Map<String, int> monthlyCount = {};
    
    // Get last 6 months
    final now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = DateFormat('MMM', 'id_ID').format(month);
      monthlyCount[monthKey] = 0;
    }

    // Count activities per month
    for (final activity in activities) {
      final monthKey = DateFormat('MMM', 'id_ID').format(activity.tanggal);
      if (monthlyCount.containsKey(monthKey)) {
        monthlyCount[monthKey] = monthlyCount[monthKey]! + 1;
      }
    }

    return monthlyCount;
  }
}
