import 'package:flutter/material.dart';

class FinanceService {
  static final FinanceService _instance = FinanceService._internal();
  factory FinanceService() => _instance;
  FinanceService._internal();

  Map<String, dynamic> getFinanceStatistics() {
    return {
      'balance': 18500000,
      'balanceChange': 12.5,
      'totalIncome': 25000000,
      'incomeChange': 8.2,
      'totalExpense': 12000000,
      'expenseChange': -3.5,
    };
  }

  List<Map<String, dynamic>> getIncomeByCategory() {
    return [
      {
        'category': 'Iuran RT',
        'amount': 15000000,
        'percentage': 60,
        'color': const Color(0xFF42A5F5),
      },
      {
        'category': 'Sumbangan',
        'amount': 6000000,
        'percentage': 24,
        'color': const Color(0xFF66BB6A),
      },
      {
        'category': 'Lainnya',
        'amount': 4000000,
        'percentage': 16,
        'color': const Color(0xFFFFB74D),
      },
    ];
  }

  List<Map<String, dynamic>> getRecentTransactions() {
    return [
      {
        'type': 'income',
        'description': 'Iuran RT Bulan Oktober',
        'date': '22 Okt 2024',
        'amount': 5000000,
      },
      {
        'type': 'expense',
        'description': 'Pembelian Perlengkapan Gotong Royong',
        'date': '20 Okt 2024',
        'amount': 1500000,
      },
      {
        'type': 'income',
        'description': 'Sumbangan Warga untuk Kegiatan 17 Agustus',
        'date': '18 Okt 2024',
        'amount': 3000000,
      },
      {
        'type': 'expense',
        'description': 'Biaya Kebersihan Lingkungan',
        'date': '15 Okt 2024',
        'amount': 2000000,
      },
      {
        'type': 'expense',
        'description': 'Perbaikan Pos Ronda',
        'date': '12 Okt 2024',
        'amount': 4500000,
      },
    ];
  }

  List<Map<String, dynamic>> getExpenseByCategory() {
    return [
      {
        'category': 'Kebersihan',
        'amount': 5000000,
        'percentage': 42,
        'color': const Color(0xFF42A5F5),
      },
      {
        'category': 'Keamanan',
        'amount': 3500000,
        'percentage': 29,
        'color': const Color(0xFF66BB6A),
      },
      {
        'category': 'Kegiatan',
        'amount': 2000000,
        'percentage': 17,
        'color': const Color(0xFFFFB74D),
      },
      {
        'category': 'Lainnya',
        'amount': 1500000,
        'percentage': 12,
        'color': const Color(0xFFEF5350),
      },
    ];
  }
}