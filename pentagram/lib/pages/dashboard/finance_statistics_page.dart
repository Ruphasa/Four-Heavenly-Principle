import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/models/transaction.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/finance_calculator.dart';
import 'package:pentagram/widgets/dashboard/finance_stat_card.dart';
import 'package:pentagram/widgets/dashboard/income_expense_bar_chart.dart';
import 'package:pentagram/widgets/dashboard/expense_category_stacked_bar.dart';
import 'package:pentagram/widgets/dashboard/finance_trend_chart.dart';

class FinanceStatisticsPage extends ConsumerStatefulWidget {
  const FinanceStatisticsPage({super.key});

  @override
  ConsumerState<FinanceStatisticsPage> createState() => _FinanceStatisticsPageState();
}

class _FinanceStatisticsPageState extends ConsumerState<FinanceStatisticsPage> {
  String _selectedPeriod = 'Bulan Ini';

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Statistik Keuangan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) => setState(() => _selectedPeriod = value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Hari Ini', child: Text('Hari Ini')),
              PopupMenuItem(value: 'Minggu Ini', child: Text('Minggu Ini')),
              PopupMenuItem(value: 'Bulan Ini', child: Text('Bulan Ini')),
              PopupMenuItem(value: 'Tahun Ini', child: Text('Tahun Ini')),
            ],
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) => _buildBody(transactions),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('Gagal memuat data keuangan: $error'),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<Transaction> transactions) {
    final stats = FinanceCalculator.calculatePeriodStats(transactions, _selectedPeriod);
    final expenseShares = FinanceCalculator.buildCategoryShares(
      transactions.where((trx) => !trx.isIncome).toList(),
    );
    final recentTransactions = FinanceCalculator.getRecentTransactions(transactions);

    // Calculate max for bar chart
    final maxValue = [stats.totalIncome, stats.totalExpense]
        .reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(stats),
          const SizedBox(height: 24),
          _buildSummaryCards(stats),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IncomeExpenseBarChart(
              totalIncome: stats.totalIncome.toDouble(),
              totalExpense: stats.totalExpense.toDouble(),
              maxY: (maxValue > 0 ? maxValue : 100).toDouble(),
            ),
          ),
          const SizedBox(height: 24),
          if (expenseShares.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ExpenseCategoryStackedBar(categoryShares: expenseShares),
            ),
            const SizedBox(height: 24),
          ],
          if (recentTransactions.isNotEmpty) ...[
            _buildRecentTransactions(recentTransactions),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic stats) {
    return Container(
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
          const Text(
            'Saldo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rp ${FinanceCalculator.formatCurrency(stats.balance)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(dynamic stats) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: FinanceStatCard(
              title: 'Pemasukan',
              amount: stats.totalIncome,
              change: stats.incomeChange,
              color: const Color(0xFF66BB6A),
              icon: Icons.arrow_downward,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FinanceStatCard(
              title: 'Pengeluaran',
              amount: stats.totalExpense,
              change: stats.expenseChange,
              color: const Color(0xFFEF5350),
              icon: Icons.arrow_upward,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(List<Transaction> transactions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
              'Transaksi Terbaru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...transactions.map((trx) => _buildTransactionItem(trx)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: transaction.isIncome
                  ? const Color(0xFF66BB6A).withOpacity(0.1)
                  : const Color(0xFFEF5350).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: transaction.isIncome
                  ? const Color(0xFF66BB6A)
                  : const Color(0xFFEF5350),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  transaction.title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            'Rp ${FinanceCalculator.formatCurrency(transaction.amount)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: transaction.isIncome
                  ? const Color(0xFF66BB6A)
                  : const Color(0xFFEF5350),
            ),
          ),
        ],
      ),
    );
  }
}
