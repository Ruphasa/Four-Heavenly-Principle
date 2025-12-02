import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;
  final double radius;

  const ProfilePictureWidget({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.radius = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: radius * 2,
                height: radius * 2,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: radius,
                    color: AppColors.primary,
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
