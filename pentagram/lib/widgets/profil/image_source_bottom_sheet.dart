import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const ImageSourceBottomSheet({
    super.key,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Sumber Foto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.camera_alt, color: AppColors.primary),
              ),
              title: const Text(
                'Kamera',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              subtitle: const Text(
                'Ambil foto KTP langsung',
                style: TextStyle(fontSize: 13),
              ),
              onTap: () {
                Navigator.pop(context);
                onCameraPressed();
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.photo_library,
                  color: AppColors.secondary,
                ),
              ),
              title: const Text(
                'Galeri',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              subtitle: const Text(
                'Pilih dari galeri foto',
                style: TextStyle(fontSize: 13),
              ),
              onTap: () {
                Navigator.pop(context);
                onGalleryPressed();
              },
            ),
          ],
        ),
      ),
    );
  }
}
