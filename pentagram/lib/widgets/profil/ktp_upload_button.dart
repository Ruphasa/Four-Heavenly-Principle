import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class KtpUploadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const KtpUploadButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
          style: BorderStyle.solid,
        ),
        color: AppColors.primary.withValues(alpha: 0.05),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(24),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Foto KTP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap untuk mengambil foto KTP',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
