import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';

/// Tab bar widget for broadcast filtering
class BroadcastTabBar extends StatelessWidget {
  final TabController controller;

  const BroadcastTabBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.padding(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: responsive.elevation(15),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.padding(4)),
        child: TabBar(
          controller: controller,
          indicator: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: responsive.elevation(8),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[600],
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: responsive.fontSize(14),
            letterSpacing: 0.3,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: responsive.fontSize(14),
            letterSpacing: 0.2,
          ),
          labelPadding: EdgeInsets.symmetric(
            horizontal: responsive.padding(8),
            vertical: responsive.padding(12),
          ),
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Urgent'),
            Tab(text: 'Terkirim'),
          ],
          dividerColor: Colors.transparent,
        ),
      ),
    );
  }
}
