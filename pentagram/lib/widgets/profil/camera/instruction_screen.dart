import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class InstructionScreen extends StatelessWidget {
  final VoidCallback onStart;

  const InstructionScreen({super.key, required this.onStart});

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
          'Pindai KTP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Icon Card
              Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.credit_card_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Cara Pindai KTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ikuti langkah berikut untuk hasil terbaik',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Instructions Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInstruction(
                      1,
                      Icons.light_mode_outlined,
                      'Pencahayaan Cukup',
                      'Pastikan ruangan memiliki cahaya yang baik',
                    ),
                    const SizedBox(height: 20),
                    _buildInstruction(
                      2,
                      Icons.screen_rotation_outlined,
                      'Rotate Otomatis',
                      'Device akan otomatis rotate ke landscape',
                    ),
                    const SizedBox(height: 20),
                    _buildInstruction(
                      3,
                      Icons.center_focus_strong_outlined,
                      'Posisi Tepat',
                      'Posisikan KTP dalam bingkai yang tersedia',
                    ),
                    const SizedBox(height: 20),
                    _buildInstruction(
                      4,
                      Icons.photo_camera_outlined,
                      'Foto Jelas',
                      'Ambil foto dengan fokus yang tajam',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Foto KTP akan otomatis ter-crop sesuai bingkai untuk hasil optimal',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Start Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Mulai Pindai',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction(
    int number,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
