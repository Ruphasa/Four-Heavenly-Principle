import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import 'package:fl_chart/fl_chart.dart';
import 'package:pentagram/models/citizen.dart';
import 'package:pentagram/models/family.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/utils/app_colors.dart';

class PopulationStatisticsPage extends ConsumerStatefulWidget {
  const PopulationStatisticsPage({super.key});

  @override
  ConsumerState<PopulationStatisticsPage> createState() => _PopulationStatisticsPageState();
}

class _PopulationStatisticsPageState extends ConsumerState<PopulationStatisticsPage> {
  String _selectedPeriod = 'Data Terkini';

  @override
  Widget build(BuildContext context) {
    final citizensAsync = ref.watch(citizensStreamProvider);
    final familiesAsync = ref.watch(familiesStreamProvider);

    return citizensAsync.when(
      data: (citizens) => familiesAsync.when(
        data: (families) {
          final analytics = _PopulationAnalytics(citizens, families);
          return _buildScaffold(context, analytics);
        },
        loading: _buildLoadingScaffold,
        error: (error, _) => _buildErrorScaffold(error),
      ),
      loading: _buildLoadingScaffold,
      error: (error, _) => _buildErrorScaffold(error),
    );
  }

  Scaffold _buildScaffold(BuildContext context, _PopulationAnalytics analytics) {
    final summary = analytics.summary;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Statistik Kependudukan',
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
              PopupMenuItem(value: 'Data Terkini', child: Text('Data Terkini')),
              PopupMenuItem(value: 'Bulan Ini', child: Text('Bulan Ini')),
              PopupMenuItem(value: 'Tahun Ini', child: Text('Tahun Ini')),
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
                    '${summary.totalPopulation} Jiwa',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${summary.totalFamilies} Kepala Keluarga',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickStatCard(
                      'Laki-laki',
                      summary.maleCount,
                      const Color(0xFF42A5F5),
                      Icons.male,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickStatCard(
                      'Perempuan',
                      summary.femaleCount,
                      const Color(0xFFEC407A),
                      Icons.female,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Gender Distribution
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildGenderDistribution(analytics.genderDistribution),
            ),

            const SizedBox(height: 24),

            // Population by Age Group
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildAgeGroupDistribution(analytics.ageGroups),
            ),

            const SizedBox(height: 24),

            // Marital Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildMaritalStatus(analytics.maritalStatuses),
            ),

            const SizedBox(height: 24),

            // Occupation Distribution
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildOccupationDistribution(analytics.occupations),
            ),

            const SizedBox(height: 24),

            // Religion Distribution
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildReligionDistribution(analytics.religions),
            ),

            const SizedBox(height: 24),

            // Education Level
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildEducationLevel(analytics.educationLevels),
            ),

            const SizedBox(height: 24),

            // Family Role Distribution
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildFamilyRoleDistribution(analytics.familyRoles),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Scaffold _buildLoadingScaffold() {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Scaffold _buildErrorScaffold(Object error) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 12),
              const Text(
                'Gagal memuat statistik',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatCard(
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 12),
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
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDistribution(List<_DistributionItem> genderData) {
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
            'Distribusi Jenis Kelamin',
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
                      centerSpaceRadius: 45,
                      sections: genderData.map((data) {
                        return PieChartSectionData(
                          value: data.count.toDouble(),
                          title: '${data.percentage.toStringAsFixed(1)}%',
                          color: data.color,
                          radius: 65,
                          titleStyle: const TextStyle(
                            fontSize: 14,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: genderData.map((data) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: data.color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.label,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${data.count} jiwa',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeGroupDistribution(List<_AgeGroupStat> ageGroups) {
    final maxCount = ageGroups.fold<int>(0, (max, item) => math.max(max, item.count));
    final maxY = (math.max(10, maxCount + 5)).toDouble();
    final gridInterval = (maxY / 4).clamp(5, 50).toDouble();

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
              Expanded(
                child: Text(
                  'Distribusi Kelompok Usia',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                maxY: maxY,
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
                        if (value.toInt() < ageGroups.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              ageGroups[value.toInt()].label,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 9,
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
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: gridInterval,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[200]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: ageGroups.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.count.toDouble(),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.primary.withOpacity(0.7),
                            AppColors.primary,
                          ],
                        ),
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
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

  Widget _buildMaritalStatus(List<_DistributionItem> maritalData) {
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
            'Status Perkawinan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...maritalData.map(_buildStatusBar),
        ],
      ),
    );
  }

  Widget _buildStatusBar(_DistributionItem data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${data.count} (${data.percentage.toStringAsFixed(1)}%)',
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
              value: data.percentage / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(data.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccupationDistribution(List<_DistributionItem> occupations) {
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
                'Distribusi Pekerjaan',
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
          const SizedBox(height: 20),
          ...occupations.map(_buildOccupationItem),
        ],
      ),
    );
  }

  Widget _buildOccupationItem(_DistributionItem occupation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: occupation.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: occupation.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              occupation.icon ?? Icons.work_outline,
              color: occupation.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  occupation.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${occupation.count} orang (${occupation.percentage.toStringAsFixed(1)}%)',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: occupation.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${occupation.percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: occupation.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReligionDistribution(List<_DistributionItem> religions) {
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
            'Distribusi Agama',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 45,
                      sections: religions.map((religion) {
                        return PieChartSectionData(
                          value: religion.count.toDouble(),
                          title: '${religion.percentage.toStringAsFixed(1)}%',
                          color: religion.color,
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
                      children: religions.map((religion) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: religion.color,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      religion.label,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${religion.count} jiwa',
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
          ),
        ],
      ),
    );
  }

  Widget _buildEducationLevel(List<_DistributionItem> educations) {
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
            'Tingkat Pendidikan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...educations.map(_buildStatusBar),
        ],
      ),
    );
  }

  Widget _buildFamilyRoleDistribution(List<_DistributionItem> roles) {
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
            'Peran dalam Keluarga',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...roles.map(_buildRoleItem),
        ],
      ),
    );
  }

  Widget _buildRoleItem(_DistributionItem role) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: role.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              role.icon ?? Icons.groups_rounded,
              color: role.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              role.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${role.count} orang',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PopulationAnalytics {
  _PopulationAnalytics(this.citizens, this.families);

  final List<Citizen> citizens;
  final List<Family> families;

  static const _categoryColors = <Color>[
    Color(0xFF42A5F5),
    Color(0xFF66BB6A),
    Color(0xFFFFB74D),
    Color(0xFFEF5350),
    Color(0xFFAB47BC),
    Color(0xFF26C6DA),
    Color(0xFF5C6BC0),
  ];

  static const _ageRanges = <_AgeGroupRange>[
    _AgeGroupRange(label: '0-5', min: 0, max: 5),
    _AgeGroupRange(label: '6-12', min: 6, max: 12),
    _AgeGroupRange(label: '13-17', min: 13, max: 17),
    _AgeGroupRange(label: '18-25', min: 18, max: 25),
    _AgeGroupRange(label: '26-40', min: 26, max: 40),
    _AgeGroupRange(label: '41-60', min: 41, max: 60),
    _AgeGroupRange(label: '>60', min: 61, max: null),
  ];

  late final _PopulationSummary summary = _PopulationSummary(
    totalPopulation: citizens.length,
    totalFamilies: families.length,
    maleCount: _countByGender('laki-laki'),
    femaleCount: _countByGender('perempuan'),
  );

  late final List<_DistributionItem> genderDistribution = [
    _DistributionItem(
      label: 'Laki-laki',
      count: summary.maleCount,
      percentage: _percentage(summary.maleCount),
      color: const Color(0xFF42A5F5),
      icon: Icons.male,
    ),
    _DistributionItem(
      label: 'Perempuan',
      count: summary.femaleCount,
      percentage: _percentage(summary.femaleCount),
      color: const Color(0xFFEC407A),
      icon: Icons.female,
    ),
  ];

  late final List<_AgeGroupStat> ageGroups = _ageRanges
      .map((range) => _AgeGroupStat(
            label: range.label,
            count: citizens.where((c) => range.contains(c.age)).length,
          ))
      .toList();

  late final List<_DistributionItem> maritalStatuses =
      _groupBy(citizens.map((c) => c.maritalStatus));

  late final List<_DistributionItem> occupations = _groupBy(
    citizens.map((c) => c.occupation),
    iconResolver: _occupationIcon,
  );

  late final List<_DistributionItem> religions =
      _groupBy(citizens.map((c) => c.religion));

  late final List<_DistributionItem> educationLevels =
      _groupBy(citizens.map((c) => c.education));

  late final List<_DistributionItem> familyRoles = _groupBy(
    citizens.map((c) => c.familyRole),
    iconResolver: _familyRoleIcon,
  );

  int _countByGender(String genderLabel) {
    final lower = genderLabel.toLowerCase();
    return citizens
        .where((citizen) => citizen.gender.toLowerCase() == lower)
        .length;
  }

  double _percentage(int count) {
    if (summary.totalPopulation == 0) return 0;
    return count / summary.totalPopulation * 100;
  }

  List<_DistributionItem> _groupBy(
    Iterable<String> values, {
    IconData? Function(String label)? iconResolver,
  }) {
    final counts = <String, int>{};
    for (final value in values) {
      final key = value.trim().isEmpty ? '-' : value.trim();
      counts[key] = (counts[key] ?? 0) + 1;
    }

    if (counts.isEmpty) return const [];

    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    int colorIndex = 0;
    return entries.map((entry) {
      final color = _categoryColors[colorIndex % _categoryColors.length];
      colorIndex++;
      return _DistributionItem(
        label: entry.key,
        count: entry.value,
        percentage: _percentage(entry.value),
        color: color,
        icon: iconResolver?.call(entry.key),
      );
    }).toList();
  }

  IconData _occupationIcon(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('karyawan')) return Icons.business_center;
    if (lower.contains('wiraswasta') || lower.contains('usaha')) return Icons.storefront;
    if (lower.contains('pns') || lower.contains('polri') || lower.contains('tni')) {
      return Icons.shield;
    }
    if (lower.contains('ibu') || lower.contains('rumah')) return Icons.home;
    if (lower.contains('pelajar') || lower.contains('mahasiswa')) return Icons.school;
    if (lower.contains('tidak') || lower.contains('belum')) return Icons.person_off;
    return Icons.work_outline;
  }

  IconData _familyRoleIcon(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('kepala')) return Icons.person;
    if (lower.contains('istri')) return Icons.female;
    if (lower.contains('suami')) return Icons.male;
    if (lower.contains('anak')) return Icons.child_care;
    if (lower.contains('ortu') || lower.contains('orang tua')) return Icons.elderly;
    if (lower.contains('cucu')) return Icons.child_friendly;
    return Icons.groups;
  }
}

class _PopulationSummary {
  final int totalPopulation;
  final int totalFamilies;
  final int maleCount;
  final int femaleCount;

  const _PopulationSummary({
    required this.totalPopulation,
    required this.totalFamilies,
    required this.maleCount,
    required this.femaleCount,
  });
}

class _DistributionItem {
  final String label;
  final int count;
  final double percentage;
  final Color color;
  final IconData? icon;

  const _DistributionItem({
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
    this.icon,
  });
}

class _AgeGroupStat {
  final String label;
  final int count;

  const _AgeGroupStat({
    required this.label,
    required this.count,
  });
}

class _AgeGroupRange {
  final String label;
  final int min;
  final int? max;

  const _AgeGroupRange({required this.label, required this.min, this.max});

  bool contains(int age) {
    if (age < min) return false;
    if (max == null) return true;
    return age <= max!;
  }
}