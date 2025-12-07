import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';

/// Stat item widget for broadcast statistics modal
class BroadcastStatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const BroadcastStatItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacing(12)),
      padding: EdgeInsets.all(responsive.padding(16)),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(responsive.padding(10)),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
            ),
            child: Icon(icon, color: AppColors.primary, size: responsive.iconSize(24)),
          ),
          SizedBox(width: responsive.spacing(16)),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: responsive.fontSize(14),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: responsive.fontSize(20),
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
