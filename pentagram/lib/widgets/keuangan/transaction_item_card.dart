import 'package:flutter/material.dart';
import 'package:pentagram/models/transaction.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';
import 'package:intl/intl.dart';

class TransactionItemCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionItemCard({
    super.key,
    required this.transaction,
  });

  String _formatDate(DateTime date) {
    final months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final icon = transaction.isIncome
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;
    final color = transaction.isIncome ? AppColors.success : AppColors.error;

    return Container(
      padding: EdgeInsets.all(responsive.padding(16)),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: responsive.elevation(8),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(responsive.padding(10)),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
            ),
            child: Icon(icon, color: color, size: responsive.iconSize(20)),
          ),
          SizedBox(width: responsive.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: TextStyle(
                    fontSize: responsive.fontSize(15),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: responsive.spacing(4)),
                Text(
                  _formatDate(transaction.date),
                  style: TextStyle(
                    fontSize: responsive.fontSize(12),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatCurrency(transaction.amount),
            style: TextStyle(
              fontSize: responsive.fontSize(15),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
