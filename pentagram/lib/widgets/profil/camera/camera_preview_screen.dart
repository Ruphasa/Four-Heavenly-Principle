import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:pentagram/utils/app_colors.dart';

class CameraPreviewScreen extends StatelessWidget {
  final CameraController cameraController;
  final VoidCallback onCapture;
  final bool isCapturing;

  const CameraPreviewScreen({
    super.key,
    required this.cameraController,
    required this.onCapture,
    required this.isCapturing,
  });

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final cameraRatio = cameraController.value.aspectRatio;

    return Stack(
      children: [
        // Camera Preview
        Center(
          child: Transform.scale(
            scale: deviceRatio / cameraRatio,
            child: AspectRatio(
              aspectRatio: cameraRatio,
              child: CameraPreview(cameraController),
            ),
          ),
        ),

        // Overlay
        const _CameraOverlay(),

        // Header
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.center_focus_strong,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Posisikan KTP dalam bingkai',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),

        // Capture Button
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: isCapturing ? null : onCapture,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.8),
                        ],
                      ),
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isCapturing
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 36,
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Tekan untuk ambil foto',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CameraOverlay extends StatelessWidget {
  const _CameraOverlay();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Untuk landscape mode, gunakan height sebagai basis
    final frameHeight = size.height * 0.7;
    final frameWidth = frameHeight * 1.59; // KTP ratio landscape (1.59:1)

    return Stack(
      children: [
        // Dark overlay
        Container(color: Colors.black.withValues(alpha: 0.5)),
        // Transparent frame
        Center(
          child: Container(
            width: frameWidth,
            height: frameHeight,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryLight, width: 3),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
