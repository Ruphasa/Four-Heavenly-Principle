import 'package:flutter/material.dart';

class PopulationService {
  static final PopulationService _instance = PopulationService._internal();
  factory PopulationService() => _instance;
  PopulationService._internal();

  Map<String, dynamic> getPopulationStatistics() {
    return {
      'totalPopulation': 342,
      'totalFamilies': 85,
      'maleCount': 178,
      'femaleCount': 164,
    };
  }

  List<Map<String, dynamic>> getGenderDistribution() {
    return [
      {
        'gender': 'Laki-laki',
        'count': 178,
        'percentage': 52,
        'color': const Color(0xFF42A5F5),
      },
      {
        'gender': 'Perempuan',
        'count': 164,
        'percentage': 48,
        'color': const Color(0xFFEC407A),
      },
    ];
  }

  List<Map<String, dynamic>> getAgeGroupDistribution() {
    return [
      {'ageGroup': '0-5', 'count': 28},
      {'ageGroup': '6-12', 'count': 45},
      {'ageGroup': '13-17', 'count': 38},
      {'ageGroup': '18-25', 'count': 52},
      {'ageGroup': '26-40', 'count': 78},
      {'ageGroup': '41-60', 'count': 65},
      {'ageGroup': '>60', 'count': 36},
    ];
  }

  List<Map<String, dynamic>> getMaritalStatus() {
    return [
      {
        'status': 'Belum Kawin',
        'count': 145,
        'percentage': 42,
        'color': const Color(0xFF42A5F5),
      },
      {
        'status': 'Kawin',
        'count': 168,
        'percentage': 49,
        'color': const Color(0xFF66BB6A),
      },
      {
        'status': 'Cerai Hidup',
        'count': 18,
        'percentage': 5,
        'color': const Color(0xFFFFB74D),
      },
      {
        'status': 'Cerai Mati',
        'count': 11,
        'percentage': 4,
        'color': const Color(0xFFEF5350),
      },
    ];
  }

  List<Map<String, dynamic>> getOccupationDistribution() {
    return [
      {
        'name': 'Karyawan Swasta',
        'count': 85,
        'percentage': 38,
        'color': const Color(0xFF42A5F5),
        'icon': Icons.business_center,
      },
      {
        'name': 'Wiraswasta',
        'count': 52,
        'percentage': 23,
        'color': const Color(0xFF66BB6A),
        'icon': Icons.store,
      },
      {
        'name': 'PNS/TNI/Polri',
        'count': 28,
        'percentage': 13,
        'color': const Color(0xFFFFB74D),
        'icon': Icons.shield,
      },
      {
        'name': 'Ibu Rumah Tangga',
        'count': 62,
        'percentage': 28,
        'color': const Color(0xFFEC407A),
        'icon': Icons.home,
      },
      {
        'name': 'Pelajar/Mahasiswa',
        'count': 78,
        'percentage': 35,
        'color': const Color(0xFFAB47BC),
        'icon': Icons.school,
      },
      {
        'name': 'Belum/Tidak Bekerja',
        'count': 37,
        'percentage': 17,
        'color': const Color(0xFF78909C),
        'icon': Icons.person_off,
      },
    ];
  }

  List<Map<String, dynamic>> getReligionDistribution() {
    return [
      {
        'name': 'Islam',
        'count': 312,
        'percentage': 91,
        'color': const Color(0xFF66BB6A),
      },
      {
        'name': 'Kristen',
        'count': 18,
        'percentage': 5,
        'color': const Color(0xFF42A5F5),
      },
      {
        'name': 'Katolik',
        'count': 8,
        'percentage': 2,
        'color': const Color(0xFFFFB74D),
      },
      {
        'name': 'Hindu',
        'count': 3,
        'percentage': 1,
        'color': const Color(0xFFEF5350),
      },
      {
        'name': 'Buddha',
        'count': 1,
        'percentage': 1,
        'color': const Color(0xFFAB47BC),
      },
    ];
  }

  List<Map<String, dynamic>> getEducationLevel() {
    return [
      {
        'status': 'Tidak/Belum Sekolah',
        'count': 32,
        'percentage': 9,
        'color': const Color(0xFFEF5350),
      },
      {
        'status': 'SD/Sederajat',
        'count': 65,
        'percentage': 19,
        'color': const Color(0xFFFFB74D),
      },
      {
        'status': 'SMP/Sederajat',
        'count': 58,
        'percentage': 17,
        'color': const Color(0xFFFFCA28),
      },
      {
        'status': 'SMA/Sederajat',
        'count': 112,
        'percentage': 33,
        'color': const Color(0xFF66BB6A),
      },
      {
        'status': 'D1/D2/D3',
        'count': 28,
        'percentage': 8,
        'color': const Color(0xFF42A5F5),
      },
      {
        'status': 'S1/D4',
        'count': 38,
        'percentage': 11,
        'color': const Color(0xFF5C6BC0),
      },
      {
        'status': 'S2/S3',
        'count': 9,
        'percentage': 3,
        'color': const Color(0xFFAB47BC),
      },
    ];
  }

  List<Map<String, dynamic>> getFamilyRoleDistribution() {
    return [
      {
        'name': 'Kepala Keluarga',
        'count': 85,
        'color': const Color(0xFF42A5F5),
        'icon': Icons.person,
      },
      {
        'name': 'Istri',
        'count': 83,
        'color': const Color(0xFFEC407A),
        'icon': Icons.person_outline,
      },
      {
        'name': 'Anak',
        'count': 156,
        'color': const Color(0xFF66BB6A),
        'icon': Icons.child_care,
      },
      {
        'name': 'Orang Tua',
        'count': 12,
        'color': const Color(0xFFFFB74D),
        'icon': Icons.elderly,
      },
      {
        'name': 'Lainnya',
        'count': 6,
        'color': const Color(0xFF78909C),
        'icon': Icons.groups,
      },
    ];
  }
}