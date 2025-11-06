import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class DetailWargaPage extends StatelessWidget {
  final String name;
  final String nik;
  final String role;
  final String status;

  const DetailWargaPage({
    super.key,
    required this.name,
    required this.nik,
    required this.role,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: const Text('Detail Warga'),
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
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text('NIK: $nik', style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text('Peran: $role', style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text('Status: $status', style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for more details (alamat, kontak, riwayat)
            Text('Informasi tambahan bisa ditampilkan di sini.', style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
