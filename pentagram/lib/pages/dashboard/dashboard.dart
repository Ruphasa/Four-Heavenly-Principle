import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/models/activity.dart';
import 'package:pentagram/models/activity_log.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/widgets/dashboard/dashboard_app_bar.dart';
import 'package:pentagram/widgets/dashboard/upcoming_events_section.dart';
import 'package:pentagram/widgets/dashboard/quick_access_section.dart';
import 'package:pentagram/widgets/dashboard/statistics_section.dart';
import 'package:pentagram/widgets/dashboard/activity_log_section.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final activitiesAsync = ref.watch(activitiesStreamProvider);
    final logsAsync = ref.watch(activityLogsStreamProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DashboardAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildUpcomingSection(activitiesAsync),
            const SizedBox(height: 24),
            const QuickAccessSection(),
            const SizedBox(height: 24),
            const StatisticsSection(),
            const SizedBox(height: 24),
            _buildActivityLogSection(logsAsync),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingSection(AsyncValue<List<Activity>> activitiesAsync) {
    return activitiesAsync.when(
      data: (activities) {
        final upcoming = _getUpcomingActivities(activities);
        return UpcomingEventsSection(activities: upcoming);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _DashboardErrorCard(
        title: 'Gagal memuat kegiatan',
        message: error.toString(),
      ),
    );
  }

  Widget _buildActivityLogSection(AsyncValue<List<ActivityLog>> logsAsync) {
    return logsAsync.when(
      data: (logs) {
        final recent = _getRecentLogs(logs);
        return ActivityLogSection(recentLogs: recent);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _DashboardErrorCard(
        title: 'Gagal memuat log',
        message: error.toString(),
      ),
    );
  }

  List<Activity> _getUpcomingActivities(List<Activity> activities) {
    final now = DateTime.now();
    return activities
        .where((activity) => activity.tanggal.isAfter(now))
        .toList()
      ..sort((a, b) => a.tanggal.compareTo(b.tanggal));
  }

  List<ActivityLog> _getRecentLogs(List<ActivityLog> logs) {
    final sorted = List<ActivityLog>.from(logs)
      ..sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return sorted.take(3).toList();
  }
}

class _DashboardErrorCard extends StatelessWidget {
  final String title;
  final String message;

  const _DashboardErrorCard({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(fontSize: 13, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}
