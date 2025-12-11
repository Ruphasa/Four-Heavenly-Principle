import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/models/activity.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/widgets/dashboard/stat_card.dart';
import 'package:pentagram/widgets/dashboard/stacked_progress_bar.dart';
import 'package:pentagram/widgets/dashboard/activity_timeline_chart.dart';

class ActivityStatisticsPage extends ConsumerStatefulWidget {
  const ActivityStatisticsPage({super.key});

  @override
  ConsumerState<ActivityStatisticsPage> createState() => _ActivityStatisticsPageState();
}

class _ActivityStatisticsPageState extends ConsumerState<ActivityStatisticsPage> {
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: activitiesAsync.when(
        data: (activities) => _buildBody(activities),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Gagal memuat: $e')),
      ),
    );
  }

  Widget _buildBody(List<Activity> activities) {
    final stat = _computeActivityStatistics(activities);
    final categories = _computeCategorySummary(activities);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildStatusCards(stat),
          const SizedBox(height: 24),
          ActivityTimelineChart(activities: activities),
          const SizedBox(height: 24),
          _buildCategoryDistribution(categories, activities.length),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Kegiatan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pantau status dan distribusi kegiatan',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCards(Map<String, dynamic> stat) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Selesai',
            value: '${stat['completed']}',
            icon: Icons.check_circle_outline,
            iconColor: const Color(0xFF66BB6A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Berlangsung',
            value: '${stat['ongoing']}',
            icon: Icons.play_circle_outline,
            iconColor: const Color(0xFF42A5F5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Mendatang',
            value: '${stat['upcoming']}',
            icon: Icons.schedule,
            iconColor: const Color(0xFFFFB74D),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDistribution(
    List<Map<String, dynamic>> distribution,
    int total,
  ) {
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
            'Distribusi Kategori',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          if (distribution.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Tidak ada data'),
              ),
            )
          else
            StackedProgressBar(
              segments: distribution.map((item) {
                return ProgressSegment(
                  label: item['category'],
                  count: item['count'],
                  percentage: item['percentage'].toDouble() / 100,
                  color: item['color'],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Map<String, dynamic> _computeActivityStatistics(List<Activity> activities) {
    final now = DateTime.now();
    int completed = 0;
    int ongoing = 0;
    int upcoming = 0;

    for (final activity in activities) {
      final activityDate = activity.tanggal;

      if (activityDate.isBefore(now.subtract(const Duration(days: 1)))) {
        completed++;
      } else if (activityDate.isAfter(now.add(const Duration(days: 1)))) {
        upcoming++;
      } else {
        ongoing++;
      }
    }

    return {
      'completed': completed,
      'ongoing': ongoing,
      'upcoming': upcoming,
    };
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
}
