import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class KtpImagePreview extends StatelessWidget {
  final File? ktpImage;

  const KtpImagePreview({super.key, required this.ktpImage});

  @override
  Widget build(BuildContext context) {
    if (ktpImage != null) {
      return _buildPreview();
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPreview() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.file(
              ktpImage!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Terverifikasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.credit_card, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Belum ada foto KTP',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ambil foto untuk verifikasi',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
