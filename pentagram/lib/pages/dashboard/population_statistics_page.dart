import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/population_analytics.dart';
import 'package:pentagram/widgets/dashboard/stat_card.dart';
import 'package:pentagram/widgets/dashboard/distribution_bar.dart';
import 'package:pentagram/widgets/population/gender_distribution_chart.dart';
import 'package:pentagram/widgets/population/age_group_distribution_chart.dart';
import 'package:pentagram/widgets/population/occupation_item.dart';
import 'package:pentagram/widgets/population/religion_pie_chart.dart';

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
          final analytics = PopulationAnalytics(citizens, families);
          return _buildContent(analytics);
        },
        loading: () => _buildLoading(),
        error: (error, _) => _buildError(error),
      ),
      loading: () => _buildLoading(),
      error: (error, _) => _buildError(error),
    );
  }

  Widget _buildContent(PopulationAnalytics analytics) {
    final summary = analytics.summary;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(summary),
            const SizedBox(height: 24),
            _buildQuickStats(summary),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GenderDistributionChart(genderData: analytics.genderDistribution),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AgeGroupDistributionChart(ageGroups: analytics.ageGroups),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildMaritalStatus(analytics.maritalStatuses),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildOccupations(analytics.occupations),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ReligionPieChart(religions: analytics.religions),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildEducationLevel(analytics.educationLevels),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildFamilyRoles(analytics.familyRoles),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      title: const Text(
        'Statistik Kependudukan',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list),
          onSelected: (value) => setState(() => _selectedPeriod = value),
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'Data Terkini', child: Text('Data Terkini')),
            PopupMenuItem(value: 'Bulan Ini', child: Text('Bulan Ini')),
            PopupMenuItem(value: 'Tahun Ini', child: Text('Tahun Ini')),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(PopulationSummary summary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
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
          const Text(
            'Total Penduduk',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${summary.totalPopulation} Jiwa',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dari ${summary.totalFamilies} Keluarga',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(PopulationSummary summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              title: 'Laki-laki',
              value: '${summary.maleCount}',
              icon: Icons.male,
              iconColor: const Color(0xFF42A5F5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              title: 'Perempuan',
              value: '${summary.femaleCount}',
              icon: Icons.female,
              iconColor: const Color(0xFFEC407A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaritalStatus(List<DistributionItem> maritalData) {
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...maritalData.map((data) => DistributionBar(
                label: data.label,
                count: data.count,
                total: maritalData.fold(0, (sum, item) => sum + item.count),
                percentage: data.percentage,
                color: data.color,
              )),
        ],
      ),
    );
  }

  Widget _buildOccupations(List<DistributionItem> occupations) {
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...occupations.map((o) => OccupationItem(occupation: o)),
        ],
      ),
    );
  }

  Widget _buildEducationLevel(List<DistributionItem> educations) {
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...educations.map((data) => DistributionBar(
                label: data.label,
                count: data.count,
                total: educations.fold(0, (sum, item) => sum + item.count),
                percentage: data.percentage,
                color: data.color,
              )),
        ],
      ),
    );
  }

  Widget _buildFamilyRoles(List<DistributionItem> roles) {
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...roles.map((role) => OccupationItem(occupation: role)),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(Object error) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text('Gagal memuat data: $error'),
        ),
      ),
    );
  }
}
