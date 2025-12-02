import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor ?? AppColors.primary, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
