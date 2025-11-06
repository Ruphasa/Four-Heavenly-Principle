import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class DetailRumahPage extends StatelessWidget {
  final String alamat;
  final String rt;
  final String rw;
  final String kepalaKeluarga;
  final String status;

  const DetailRumahPage({
    super.key,
    required this.alamat,
    required this.rt,
    required this.rw,
    required this.kepalaKeluarga,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: const Text('Detail Rumah'),
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppColors.cardBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alamat, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text('RT $rt / RW $rw', style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text('Kepala Keluarga: $kepalaKeluarga', style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text('Status: $status', style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Informasi tambahan seperti luas dan fasilitas dapat ditambahkan di sini.', style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
