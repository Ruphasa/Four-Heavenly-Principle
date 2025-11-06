import 'package:flutter/material.dart';
import 'package:pentagram/models/penerimaan_warga.dart';
import 'package:pentagram/utils/app_colors.dart';

class DetailPenerimaanWargaOverlay {
  static void show(BuildContext context, PenerimaanWarga warga) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetailPenerimaanContent(warga: warga),
    );
  }
}

class _DetailPenerimaanContent extends StatelessWidget {
  final PenerimaanWarga warga;

  const _DetailPenerimaanContent({required this.warga});

  @override
  Widget build(BuildContext context) {
    final isAccepted = warga.statusRegistrasi == 'Diterima';
    final isRejected = warga.statusRegistrasi == 'Ditolak';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Detail Pendaftaran Warga',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.iconPrimary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Foto KTP
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              warga.fotoIdentitas,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          _buildDetail('Nama', warga.nama),
          _buildDetail('Email', warga.email),
          _buildDetail('NIK', warga.nik),
          _buildDetail('Jenis Kelamin', warga.jenisKelamin),
          _buildDetail('Status Registrasi', warga.statusRegistrasi),

          const SizedBox(height: 20),
          if (!isAccepted && !isRejected)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Terima'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Tolak'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            )
          else
            ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.lock_rounded),
              label: const Text('Sudah Diproses'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                foregroundColor: Colors.white,
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(title,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600))),
          Expanded(
              flex: 3,
              child: Text(value,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
