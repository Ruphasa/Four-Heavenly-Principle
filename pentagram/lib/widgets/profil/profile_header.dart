import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;
  final bool isVerified;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.role,
    required this.imagePath,
    this.isVerified = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildProfilePicture(),
            const SizedBox(height: 16),
            _buildNameAndBadge(),
            const SizedBox(height: 8),
            _buildRole(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.primary,
                  );
                },
              ),
            ),
          ),
        ),
        if (isVerified)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ),
      ],
    );
  }

  Widget _buildNameAndBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isVerified) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRole() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
