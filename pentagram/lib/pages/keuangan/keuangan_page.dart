import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pentagram/models/transaction.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/widgets/common/common_header.dart';
import 'package:pentagram/widgets/keuangan/finance_summary_card.dart';
import 'package:pentagram/widgets/keuangan/finance_filter_toggle.dart';
import 'package:pentagram/widgets/keuangan/transaction_item_card.dart';
import 'package:pentagram/widgets/keuangan/add_transaction_form.dart';
import 'package:pentagram/pages/keuangan/cetak_laporan_page.dart';

class KeuanganPage extends ConsumerStatefulWidget {
  const KeuanganPage({super.key});

  @override
  ConsumerState<KeuanganPage> createState() => _KeuanganPageState();
}

class _KeuanganPageState extends ConsumerState<KeuanganPage> {
  bool _showIncome = true;

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  int _calculateTotal(List<Transaction> list) {
    return list.fold(0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            CommonHeader(
              title: 'Keuangan',
              actions: [
                IconButton(
                  icon: const Icon(Icons.print, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CetakLaporanPage(),
                      ),
                    );
                  },
                  tooltip: 'Cetak Laporan',
                ),
              ],
            ),
            transactionsAsync.when(
              data: (transactions) => _buildTransactionSliver(transactions),
              loading: () => const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text('Gagal memuat transaksi: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddTransactionForm(context),
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
    );
  }

  SliverPadding _buildTransactionSliver(List<Transaction> transactions) {
    final incomeList = transactions
        .where((transaction) => transaction.isIncome)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final expenseList = transactions
        .where((transaction) => !transaction.isIncome)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final visibleList = _showIncome ? incomeList : expenseList;

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _buildTopSummary(incomeList, expenseList),
          const SizedBox(height: 24),
          _buildFilterToggle(),
          const SizedBox(height: 16),
          ..._buildTransactionList(visibleList),
        ]),
      ),
    );
  }

  Widget _buildTopSummary(
    List<Transaction> incomeList,
    List<Transaction> expenseList,
  ) {
    return Row(
      children: [
        Expanded(
          child: FinanceSummaryCard(
            title: 'Pemasukan',
            amount: _formatCurrency(_calculateTotal(incomeList)),
            icon: Icons.arrow_downward_rounded,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FinanceSummaryCard(
            title: 'Pengeluaran',
            amount: _formatCurrency(_calculateTotal(expenseList)),
            icon: Icons.arrow_upward_rounded,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterToggle() {
    return FinanceFilterToggle(
      showIncome: _showIncome,
      onChanged: (value) {
        setState(() => _showIncome = value);
      },
    );
  }

  List<Widget> _buildTransactionList(List<Transaction> data) {
    if (data.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                _showIncome
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                size: 32,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                _showIncome
                    ? 'Belum ada pemasukan'
                    : 'Belum ada pengeluaran',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Gunakan tombol tambah untuk mencatat transaksi baru.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ];
    }

    return data
        .map((transaction) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TransactionItemCard(transaction: transaction),
            ))
        .toList();
  }

  Future<void> _showAddTransactionForm(BuildContext context) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddTransactionForm(isIncome: _showIncome),
    );

    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _showIncome
                ? 'Pemasukan berhasil disimpan'
                : 'Pengeluaran berhasil disimpan',
          ),
        ),
      );
    }
  }
}