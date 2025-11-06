import 'package:flutter/material.dart';
import 'package:pentagram/utils/responsive_helper.dart';

class QuickAccessCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickAccessCard({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: responsive.isCompact ? 80 : 90,
        height: responsive.isCompact ? 80 : 90,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: responsive.elevation(6),
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: responsive.iconSize(32), color: Colors.white),
            SizedBox(height: responsive.spacing(4)),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: responsive.fontSize(12),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
