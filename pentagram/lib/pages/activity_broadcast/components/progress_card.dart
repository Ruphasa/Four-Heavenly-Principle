import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/models/activity.dart';
import 'package:pentagram/providers/firestore_providers.dart';

class ProgressCard extends ConsumerWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activitiesStreamProvider);

    return activitiesAsync.when(
      data: (activities) {
        final stats = _computeMonthlyStats(activities);
        final total = stats['total'] as int;
        final completed = stats['completed'] as int;
        final percentage = stats['percentage'] as int;
        final progressValue = total > 0 ? completed / total : 0.0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
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
                    'Progress Bulan Ini',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getProgressColor(percentage).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$percentage%',
                      style: TextStyle(
                        color: _getProgressColor(percentage),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 10,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(percentage),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$completed/$total Kegiatan Selesai',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if ((stats['remaining'] as int) > 0)
                    Text(
                      '${stats['remaining']} tersisa',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => _loadingCard(),
      error: (_, __) => _loadingCard(),
    );
  }

  Map<String, dynamic> _computeMonthlyStats(List<Activity> activities) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final monthly = activities.where((a) =>
        !a.tanggal.isBefore(startOfMonth) && !a.tanggal.isAfter(endOfMonth));
    final total = monthly.length;

    final completed = monthly
        .where((a) => a.tanggal.isBefore(DateTime(now.year, now.month, now.day)))
        .length;

    final percentage = total > 0 ? ((completed / total) * 100).round() : 0;
    final remaining = total - completed;

    return {
      'total': total,
      'completed': completed,
      'percentage': percentage,
      'remaining': remaining,
    };
  }

  /// Get progress color based on percentage
  Color _getProgressColor(int percentage) {
    if (percentage >= 75) {
      return Colors.green;
    } else if (percentage >= 50) {
      return Colors.orange;
    } else if (percentage >= 25) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  Widget _loadingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 6, child: LinearProgressIndicator()),
          SizedBox(height: 12),
          SizedBox(height: 10, child: LinearProgressIndicator()),
        ],
      ),
    );
  }
}