import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class DetailKeluargaPage extends StatelessWidget {
  final String namaKeluarga;
  final String kepalaKeluarga;
  final int jumlahAnggota;
  final String alamat;

  const DetailKeluargaPage({
    super.key,
    required this.namaKeluarga,
    required this.kepalaKeluarga,
    required this.jumlahAnggota,
    required this.alamat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: const Text('Detail Keluarga'),
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
                    Text(namaKeluarga, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text('Kepala Keluarga: $kepalaKeluarga', style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text('Jumlah Anggota: $jumlahAnggota', style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text('Alamat: $alamat', style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Daftar anggota dan informasi kontak dapat ditambahkan di sini.', style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
