import 'package:flutter/material.dart';
import 'package:pentagram/widgets/dashboard/stacked_progress_bar.dart';

class ExpenseCategoryStackedBar extends StatelessWidget {
  final List<dynamic> categoryShares;

  const ExpenseCategoryStackedBar({
    super.key,
    required this.categoryShares,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryShares.isEmpty) {
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
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('Tidak ada data pengeluaran'),
          ),
        ),
      );
    }

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
                'Kategori Pengeluaran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${categoryShares.length} Kategori',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          StackedProgressBar(
            height: 40,
            segments: categoryShares.asMap().entries.map((entry) {
              final index = entry.key;
              final share = entry.value;
              return ProgressSegment(
                label: share.label,
                count: share.amount.toInt(),
                percentage: share.percentage / 100,
                color: _getCategoryColor(index),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          _buildTotalExpense(),
        ],
      ),
    );
  }

  Widget _buildTotalExpense() {
    final total = categoryShares.fold<double>(
      0,
      (sum, share) => sum + share.amount.toDouble(),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.shade200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                color: Colors.red.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Total Pengeluaran',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade900,
                ),
              ),
            ],
          ),
          Text(
            'Rp ${_formatCurrency(total)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      const Color(0xFFEF5350), // Red
      const Color(0xFFEC407A), // Pink
      const Color(0xFFAB47BC), // Purple
      const Color(0xFF5C6BC0), // Indigo
      const Color(0xFF42A5F5), // Blue
      const Color(0xFF26C6DA), // Cyan
      const Color(0xFF26A69A), // Teal
      const Color(0xFF66BB6A), // Green
      const Color(0xFF9CCC65), // Light Green
      const Color(0xFFFFEE58), // Yellow
      const Color(0xFFFFCA28), // Amber
      const Color(0xFFFF7043), // Deep Orange
    ];
    return colors[index % colors.length];
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}Jt';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
