import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';
import 'package:pentagram/models/user.dart';

class UserCard extends ConsumerWidget {
  final AppUser user;
  final VoidCallback? onTap;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Disetujui':
        return AppColors.success;
      case 'Ditolak':
        return AppColors.error;
      case 'Menunggu':
        return AppColors.warning;
      default:
        return AppColors.textMuted;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Disetujui':
        return Icons.check_circle_rounded;
      case 'Ditolak':
        return Icons.cancel_rounded;
      case 'Menunggu':
        return Icons.access_time_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: responsive.spacing(12)),
          padding: EdgeInsets.all(responsive.padding(16)),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: responsive.elevation(6),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // User Avatar
                  Container(
                    width: responsive.isCompact ? 48 : 56,
                    height: responsive.isCompact ? 48 : 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
                    ),
                    child: Center(
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                        style: TextStyle(
                          color: AppColors.textOnPrimary,
                          fontSize: responsive.fontSize(24),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.spacing(12)),
                  
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize: responsive.fontSize(16),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: responsive.spacing(4)),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: responsive.iconSize(14),
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: responsive.spacing(4)),
                            Expanded(
                              child: Text(
                                user.email,
                                style: TextStyle(
                                  fontSize: responsive.fontSize(13),
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: responsive.spacing(12)),
              
              // Status Badge & Phone
              Row(
                children: [
                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.padding(12),
                      vertical: responsive.padding(6),
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(user.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
                      border: Border.all(
                        color: _getStatusColor(user.status).withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(user.status),
                          size: responsive.iconSize(14),
                          color: _getStatusColor(user.status),
                        ),
                        SizedBox(width: responsive.spacing(4)),
                        Text(
                          user.status,
                          style: TextStyle(
                            fontSize: responsive.fontSize(12),
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(user.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  if (user.phone != null && user.phone!.isNotEmpty) ...[
                    SizedBox(width: responsive.spacing(12)),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: responsive.iconSize(14),
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: responsive.spacing(4)),
                          Expanded(
                            child: Text(
                              user.phone!,
                              style: TextStyle(
                                fontSize: responsive.fontSize(12),
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
