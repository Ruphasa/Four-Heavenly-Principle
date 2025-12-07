import 'package:flutter/material.dart';
import 'package:pentagram/models/citizen.dart';
import 'package:pentagram/models/family.dart';

class PopulationAnalytics {
  PopulationAnalytics(this.citizens, this.families);

  final List<Citizen> citizens;
  final List<Family> families;

  static const categoryColors = <Color>[
    Color(0xFF42A5F5),
    Color(0xFF66BB6A),
    Color(0xFFFFB74D),
    Color(0xFFEF5350),
    Color(0xFFAB47BC),
    Color(0xFF26C6DA),
    Color(0xFF5C6BC0),
  ];

  static const ageRanges = <AgeGroupRange>[
    AgeGroupRange(label: '0-5', min: 0, max: 5),
    AgeGroupRange(label: '6-12', min: 6, max: 12),
    AgeGroupRange(label: '13-17', min: 13, max: 17),
    AgeGroupRange(label: '18-25', min: 18, max: 25),
    AgeGroupRange(label: '26-40', min: 26, max: 40),
    AgeGroupRange(label: '41-60', min: 41, max: 60),
    AgeGroupRange(label: '>60', min: 61, max: null),
  ];

  late final PopulationSummary summary = PopulationSummary(
    totalPopulation: citizens.length,
    totalFamilies: families.length,
    maleCount: _countByGender('laki-laki'),
    femaleCount: _countByGender('perempuan'),
  );

  late final List<DistributionItem> genderDistribution = [
    DistributionItem(
      label: 'Laki-laki',
      count: summary.maleCount,
      percentage: _percentage(summary.maleCount),
      color: const Color(0xFF42A5F5),
      icon: Icons.male,
    ),
    DistributionItem(
      label: 'Perempuan',
      count: summary.femaleCount,
      percentage: _percentage(summary.femaleCount),
      color: const Color(0xFFEC407A),
      icon: Icons.female,
    ),
  ];

  late final List<AgeGroupStat> ageGroups = ageRanges
      .map((range) => AgeGroupStat(
            label: range.label,
            count: citizens.where((c) => range.contains(c.age)).length,
          ))
      .toList();

  late final List<DistributionItem> maritalStatuses =
      _groupBy(citizens.map((c) => c.maritalStatus));

  late final List<DistributionItem> occupations = _groupBy(
    citizens.map((c) => c.occupation),
    iconResolver: _occupationIcon,
  );

  late final List<DistributionItem> religions =
      _groupBy(citizens.map((c) => c.religion));

  late final List<DistributionItem> educationLevels =
      _groupBy(citizens.map((c) => c.education));

  late final List<DistributionItem> familyRoles = _groupBy(
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

  List<DistributionItem> _groupBy(
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
      final color = categoryColors[colorIndex % categoryColors.length];
      colorIndex++;
      return DistributionItem(
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

class PopulationSummary {
  final int totalPopulation;
  final int totalFamilies;
  final int maleCount;
  final int femaleCount;

  const PopulationSummary({
    required this.totalPopulation,
    required this.totalFamilies,
    required this.maleCount,
    required this.femaleCount,
  });
}

class DistributionItem {
  final String label;
  final int count;
  final double percentage;
  final Color color;
  final IconData? icon;

  const DistributionItem({
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
    this.icon,
  });
}

class AgeGroupStat {
  final String label;
  final int count;

  const AgeGroupStat({
    required this.label,
    required this.count,
  });
}

class AgeGroupRange {
  final String label;
  final int min;
  final int? max;

  const AgeGroupRange({required this.label, required this.min, this.max});

  bool contains(int age) {
    if (age < min) return false;
    if (max == null) return true;
    return age <= max!;
  }
}
