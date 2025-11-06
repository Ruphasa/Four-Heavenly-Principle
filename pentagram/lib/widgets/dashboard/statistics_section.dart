import 'package:flutter/material.dart';
import 'package:pentagram/pages/dashboard/activity_statistics_page.dart';
import 'package:pentagram/pages/dashboard/components/stat_card.dart';
import 'package:pentagram/pages/dashboard/finance_statistics_page.dart';
import 'package:pentagram/pages/dashboard/population_statistics_page.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistik',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          StatCard(
            title: 'Keuangan',
            lightColor: const Color(0xFF81C784),
            darkColor: const Color(0xFF66BB6A),
            icon: Icons.attach_money,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FinanceStatisticsPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          StatCard(
            title: 'Kegiatan',
            lightColor: const Color(0xFF64B5F6),
            darkColor: const Color(0xFF42A5F5),
            icon: Icons.grid_view,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActivityStatisticsPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          StatCard(
            title: 'Kependudukan',
            lightColor: const Color(0xFFE57373),
            darkColor: const Color(0xFFC62828),
            icon: Icons.people,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PopulationStatisticsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
