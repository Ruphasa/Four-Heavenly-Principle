import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class ImagePreviewScreen extends StatelessWidget {
  final File image;
  final VoidCallback onConfirm;
  final VoidCallback onRetake;

  const ImagePreviewScreen({
    super.key,
    required this.image,
    required this.onConfirm,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Preview Foto KTP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Image Preview
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(image, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Info text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Foto sudah ter-crop otomatis. Pastikan KTP jelas dan terbaca',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Retake Button
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: onRetake,
                        icon: const Icon(Icons.refresh, size: 20),
                        label: const Text(
                          'Foto Ulang',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Confirm Button
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: onConfirm,
                        icon: const Icon(Icons.check_circle, size: 20),
                        label: const Text(
                          'Gunakan Foto',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
