import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';

class FinanceSummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  const FinanceSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Container(
      padding: EdgeInsets.all(responsive.padding(16)),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: responsive.elevation(10),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(responsive.padding(8)),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
            ),
            child: Icon(icon, color: color, size: responsive.iconSize(20)),
          ),
          SizedBox(height: responsive.spacing(12)),
          Text(
            title,
            style: TextStyle(
              fontSize: responsive.fontSize(12),
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: responsive.spacing(4)),
          Text(
            amount,
            style: TextStyle(
              fontSize: responsive.fontSize(16),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
