import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/models/activity.dart';
import 'package:pentagram/models/activity_log.dart';
import 'package:pentagram/services/activity_service.dart';
import 'package:pentagram/services/activity_log_service.dart';
import 'package:pentagram/widgets/dashboard/dashboard_app_bar.dart';
import 'package:pentagram/widgets/dashboard/upcoming_events_section.dart';
import 'package:pentagram/widgets/dashboard/quick_access_section.dart';
import 'package:pentagram/widgets/dashboard/statistics_section.dart';
import 'package:pentagram/widgets/dashboard/activity_log_section.dart';
import 'package:pentagram/providers/app_providers.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  ActivityService get _activityService => ref.read(activityServiceProvider);
  ActivityLogService get _activityLogService => ref.read(activityLogServiceProvider);

  late List<Activity> _upcomingActivities;
  late List<ActivityLog> _recentLogs;

  @override
  void initState() {
    super.initState();
    // Listen for provider errors and surface them
    ref.listen(logAktivitasControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    });
    _loadData();
  }

  /// Load all data from services
  void _loadData() {
    setState(() {
      _upcomingActivities = _activityService.getUpcomingActivities();
      _recentLogs = _activityLogService.getRecentActivityLogs(limit: 3);
    });
    // Trigger background refresh on controllers (no-op for sync services now)
    ref.read(activityControllerProvider.notifier).refresh();
    ref.read(logAktivitasControllerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DashboardAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            UpcomingEventsSection(activities: _upcomingActivities),
            const SizedBox(height: 24),
            const QuickAccessSection(),
            const SizedBox(height: 24),
            const StatisticsSection(),
            const SizedBox(height: 24),
            ActivityLogSection(recentLogs: _recentLogs),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
