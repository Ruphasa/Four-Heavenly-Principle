import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/models/activity.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pentagram/providers/app_providers.dart';

class ActivityStatisticsPage extends ConsumerStatefulWidget {
  const ActivityStatisticsPage({super.key});

  @override
  ConsumerState<ActivityStatisticsPage> createState() => _ActivityStatisticsPageState();
}

class _ActivityStatisticsPageState extends ConsumerState<ActivityStatisticsPage> {
  String _selectedPeriod = 'Bulan Ini';

  @override
  Widget build(BuildContext context) {
    final activitiesAsync = ref.watch(activitiesStreamProvider);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Statistik Kegiatan',
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
              ref.read(activityControllerProvider.notifier).refresh();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Hari Ini', child: Text('Hari Ini')),
              const PopupMenuItem(value: 'Minggu Ini', child: Text('Minggu Ini')),
              const PopupMenuItem(value: 'Bulan Ini', child: Text('Bulan Ini')),
              const PopupMenuItem(value: 'Tahun Ini', child: Text('Tahun Ini')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    activitiesAsync.when(
                      data: (data) => '${data.length} Kegiatan',
                      loading: () => 'Memuat…',
                      error: (_, __) => '0 Kegiatan',
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.trending_up, color: Colors.greenAccent, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Aktivitas berjalan',
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

            // Status Cards (Completed, Ongoing, Upcoming)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: activitiesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Text('Gagal memuat: $e'),
                data: (data) {
                  final stat = _computeActivityStatistics(data);
                  return Row(
                    children: [
                      Expanded(
                        child: _buildStatusCard(
                          'Selesai',
                          stat['completed'] as int,
                          const Color(0xFF66BB6A),
                          Icons.check_circle_outline,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatusCard(
                          'Berlangsung',
                          stat['ongoing'] as int,
                          const Color(0xFF42A5F5),
                          Icons.play_circle_outline,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatusCard(
                          'Mendatang',
                          stat['upcoming'] as int,
                          const Color(0xFFFFB74D),
                          Icons.schedule,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Activity Timeline Chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildActivityTimelineChart(),
            ),

            const SizedBox(height: 24),

            // Activity by Category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildActivityByCategory(),
            ),

            const SizedBox(height: 24),

            // Top Contributors
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildTopContributors(),
            ),

            const SizedBox(height: 24),

            // Participation Statistics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildParticipationStats(),
            ),

            const SizedBox(height: 24),

            // Category Distribution
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildCategoryDistribution(),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _computeActivityStatistics(List<Activity> activities) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int completed = 0;
    int ongoing = 0;
    int upcoming = 0;

    for (final a in activities) {
      final d = DateTime(a.tanggal.year, a.tanggal.month, a.tanggal.day);
      if (d.isBefore(today)) {
        completed++;
      } else if (d.isAtSameMomentAs(today)) {
        ongoing++;
      } else {
        upcoming++;
      }
    }

    return {
      'completed': completed,
      'ongoing': ongoing,
      'upcoming': upcoming,
    };
  }

  Widget _buildStatusCard(
    String title,
    int count,
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
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTimelineChart() {
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
                'Timeline Kegiatan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Detail'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 8,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
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
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
                        if (value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
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
                barGroups: [
                  _buildBarGroup(0, 3),
                  _buildBarGroup(1, 5),
                  _buildBarGroup(2, 4),
                  _buildBarGroup(3, 6),
                  _buildBarGroup(4, 4),
                  _buildBarGroup(5, 5),
                  _buildBarGroup(6, 7),
                  _buildBarGroup(7, 6),
                  _buildBarGroup(8, 5),
                  _buildBarGroup(9, 7),
                  _buildBarGroup(10, 8),
                  _buildBarGroup(11, 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.primary.withOpacity(0.7),
              AppColors.primary,
            ],
          ),
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildActivityByCategory() {
    final activitiesAsync = ref.watch(activitiesStreamProvider);
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
            'Proporsi Kategori Kegiatan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          activitiesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Gagal memuat: $e'),
            data: (data) {
              final categories = _computeCategorySummary(data);
              return SizedBox(
                height: 220,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 45,
                          sections: categories.map((cat) {
                            return PieChartSectionData(
                              value: (cat['count'] as int).toDouble(),
                              title: '${cat['percentage']}%',
                              color: cat['color'] as Color,
                              radius: 65,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: categories.map((cat) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: cat['color'] as Color,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cat['category'] as String,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${cat['count']} kegiatan',
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
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopContributors() {
    final activitiesAsync = ref.watch(activitiesStreamProvider);
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
                'Penanggung Jawab Paling Aktif',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.emoji_events, color: Colors.amber[700], size: 24),
            ],
          ),
          const SizedBox(height: 20),
          activitiesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Gagal memuat: $e'),
            data: (data) {
              final contributors = _computeTopContributors(data);
              return Column(
                children: contributors.asMap().entries.map((entry) {
                  final index = entry.key;
                  final contributor = entry.value;
                  return _buildContributorItem(contributor, index);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContributorItem(Map<String, dynamic> contributor, int index) {
    final rankColors = [
      const Color(0xFFFFD700), // Gold
      const Color(0xFFC0C0C0), // Silver
      const Color(0xFFCD7F32), // Bronze
    ];
    
    final rankColor = index < 3 ? rankColors[index] : Colors.grey[400]!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: index < 3 ? rankColor.withOpacity(0.3) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: index < 3 
                    ? [rankColor.withOpacity(0.7), rankColor]
                    : [Colors.grey[400]!, Colors.grey[500]!],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contributor['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.event, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${contributor['activities']} kegiatan',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.people, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${contributor['participants']} peserta',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (index < 3)
            Icon(
              Icons.emoji_events,
              color: rankColor,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildParticipationStats() {
    final activitiesAsync = ref.watch(activitiesStreamProvider);
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
            'Statistik Partisipasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          activitiesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Gagal memuat: $e'),
            data: (data) {
              final totalParticipants = data.fold<int>(0, (sum, a) => sum + a.peserta);
              final totalActivities = data.length;
              final avg = totalActivities > 0 ? (totalParticipants / totalActivities).round() : 0;
              final maxAct = data.isNotEmpty ? data.reduce((a, b) => a.peserta >= b.peserta ? a : b) : null;
              final minAct = data.isNotEmpty ? data.reduce((a, b) => a.peserta <= b.peserta ? a : b) : null;

              return Column(
                children: [
                  _buildParticipationItem(
                    'Total Peserta',
                    '$totalParticipants',
                    'Dari semua kegiatan',
                    Icons.groups,
                    const Color(0xFF42A5F5),
                  ),
                  const SizedBox(height: 12),
                  _buildParticipationItem(
                    'Rata-rata per Kegiatan',
                    '$avg',
                    'Peserta per kegiatan',
                    Icons.person_outline,
                    const Color(0xFF66BB6A),
                  ),
                  const SizedBox(height: 12),
                  _buildParticipationItem(
                    'Partisipasi Tertinggi',
                    '${maxAct?.peserta ?? 0}',
                    maxAct?.nama ?? '-',
                    Icons.trending_up,
                    const Color(0xFFFFB74D),
                  ),
                  const SizedBox(height: 12),
                  _buildParticipationItem(
                    'Partisipasi Terendah',
                    '${minAct?.peserta ?? 0}',
                    minAct?.nama ?? '-',
                    Icons.trending_down,
                    const Color(0xFFEF5350),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildParticipationItem(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDistribution() {
    final activitiesAsync = ref.watch(activitiesStreamProvider);
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
            'Distribusi Kegiatan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          activitiesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Gagal memuat: $e'),
            data: (data) {
              final distribution = _computeCategorySummary(data);
              return Column(
                children: distribution.map((item) => _buildDistributionBar(item)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionBar(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item['category'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${item['count']} (${item['percentage']}%)',
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
              value: item['percentage'] / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(item['color']),
            ),
          ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> _computeCategorySummary(List<Activity> activities) {
  if (activities.isEmpty) return [];
  final Map<String, int> counts = {};
  for (final a in activities) {
    counts[a.kategori] = (counts[a.kategori] ?? 0) + 1;
  }
  final total = activities.length;
  final colors = [
    const Color(0xFF42A5F5),
    const Color(0xFF66BB6A),
    const Color(0xFFFFB74D),
    const Color(0xFFEF5350),
    const Color(0xFFAB47BC),
  ];
  final entries = counts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return entries.asMap().entries.map((entry) {
    final idx = entry.key;
    final e = entry.value;
    final pct = ((e.value / total) * 100).round();
    return {
      'category': e.key,
      'count': e.value,
      'percentage': pct,
      'color': colors[idx % colors.length],
    };
  }).toList();
}

List<Map<String, dynamic>> _computeTopContributors(List<Activity> activities) {
  if (activities.isEmpty) return [];
  final Map<String, Map<String, int>> agg = {};
  for (final a in activities) {
    final name = a.penanggungJawab;
    agg[name] ??= {'activities': 0, 'participants': 0};
    agg[name]!['activities'] = (agg[name]!['activities'] ?? 0) + 1;
    agg[name]!['participants'] = (agg[name]!['participants'] ?? 0) + a.peserta;
  }
  final list = agg.entries.map((e) => {
        'name': e.key,
        'activities': e.value['activities'] ?? 0,
        'participants': e.value['participants'] ?? 0,
      }).toList();
  list.sort((a, b) => (b['activities'] as int).compareTo(a['activities'] as int));
  return list.take(5).toList();
}