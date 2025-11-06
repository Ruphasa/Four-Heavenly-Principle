import 'package:flutter/material.dart';
import 'package:pentagram/utils/responsive_helper.dart';

class StatCard extends StatelessWidget {
  final String title;
  final Color lightColor;
  final Color darkColor;
  final IconData icon;
  final void Function()? onTap;

  const StatCard({
    required this.title,
    required this.lightColor,
    required this.darkColor,
    required this.icon,
    this.onTap,
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(responsive.padding(20)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [lightColor, darkColor],
          ),
          borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
          boxShadow: [
            BoxShadow(
              color: darkColor.withOpacity(0.3),
              blurRadius: responsive.elevation(10),
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(responsive.padding(12)),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: responsive.iconSize(28),
              ),
            ),
            SizedBox(width: responsive.spacing(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.fontSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: responsive.spacing(4)),
                  Text(
                    'Lihat statistik $title',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: responsive.fontSize(12),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.8),
              size: responsive.iconSize(16),
            ),
          ],
        ),
      ),
    );
  }
}