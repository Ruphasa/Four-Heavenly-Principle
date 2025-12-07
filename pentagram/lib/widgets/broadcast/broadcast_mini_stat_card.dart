import 'package:flutter/material.dart';
import 'package:pentagram/utils/responsive_helper.dart';

/// Mini stat card widget for broadcast header
class BroadcastMiniStatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const BroadcastMiniStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Container(
      padding: EdgeInsets.all(responsive.padding(12)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: responsive.iconSize(20)),
          SizedBox(height: responsive.spacing(4)),
          Text(
            '$value',
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: responsive.fontSize(10),
            ),
          ),
        ],
      ),
    );
  }
}
