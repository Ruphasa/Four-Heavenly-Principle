import 'package:flutter/material.dart';
import 'package:pentagram/models/activity_log.dart';
import 'package:pentagram/pages/log_aktivitas/log_aktivitas_page.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/widgets/log_aktivitas/log_aktivitas_card.dart';

class ActivityLogSection extends StatelessWidget {
  final List<ActivityLog> recentLogs;

  const ActivityLogSection({
    super.key,
    required this.recentLogs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Log Aktivitas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...recentLogs.map((log) => LogAktivitasCard(aktivitas: log)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LogAktivitasPage()),
                );
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              child: const Text('Lihat Semua →'),
            ),
          ),
        ],
      ),
    );
  }
}
