import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';
import 'package:pentagram/widgets/broadcast/broadcast_mini_stat_card.dart';

/// Header widget for broadcast page with stats
class BroadcastHeader extends StatelessWidget {
  final int totalMessages;
  final int sentMessages;
  final int urgentMessages;
  final int todayMessages;
  final VoidCallback onInfoPressed;

  const BroadcastHeader({
    super.key,
    required this.totalMessages,
    required this.sentMessages,
    required this.urgentMessages,
    required this.todayMessages,
    required this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Container(
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
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(responsive.padding(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(responsive.padding(8)),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(responsive.borderRadius(12)),
                        ),
                        child: Icon(
                          Icons.campaign,
                          color: Colors.white,
                          size: responsive.iconSize(24),
                        ),
                      ),
                      SizedBox(width: responsive.spacing(12)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Broadcast',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: responsive.fontSize(12),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$totalMessages',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.fontSize(24),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: onInfoPressed,
                    icon: const Icon(Icons.info_outline),
                    color: Colors.white,
                    iconSize: responsive.iconSize(28),
                  ),
                ],
              ),
              SizedBox(height: responsive.spacing(20)),
              Text(
                'Broadcast Pesan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: responsive.fontSize(28),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: responsive.spacing(8)),
              Text(
                'Kirim pengumuman dan informasi ke warga RT',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: responsive.fontSize(15),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: responsive.spacing(24)),
              Row(
                children: [
                  Expanded(
                    child: BroadcastMiniStatCard(
                      label: 'Terkirim',
                      value: sentMessages,
                      icon: Icons.check_circle,
                    ),
                  ),
                  SizedBox(width: responsive.spacing(12)),
                  Expanded(
                    child: BroadcastMiniStatCard(
                      label: 'Urgent',
                      value: urgentMessages,
                      icon: Icons.priority_high,
                    ),
                  ),
                  SizedBox(width: responsive.spacing(12)),
                  Expanded(
                    child: BroadcastMiniStatCard(
                      label: 'Hari Ini',
                      value: todayMessages,
                      icon: Icons.today,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
