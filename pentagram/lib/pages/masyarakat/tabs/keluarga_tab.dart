import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/pages/mutasi_keluarga/daftar_page.dart';
import 'package:pentagram/widgets/masyarakat/keluarga_card.dart';

class KeluargaTab extends StatelessWidget {
  const KeluargaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
      child: Column(
        children: [
          // Button Mutasi Keluarga
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DaftarMutasiPage(),
                  ),
                );
              },
              icon: const Icon(Icons.swap_horiz_rounded),
              label: const Text('Lihat Mutasi Keluarga'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Keluarga List
          const KeluargaCard(
            namaKeluarga: 'Keluarga Ahmad Subarjo',
            kepalaKeluarga: 'Ahmad Subarjo',
            jumlahAnggota: 4,
            alamat: 'Jl. Mawar No. 12',
          ),
          const SizedBox(height: 12),
          const KeluargaCard(
            namaKeluarga: 'Keluarga Budi Santoso',
            kepalaKeluarga: 'Budi Santoso',
            jumlahAnggota: 3,
            alamat: 'Jl. Melati No. 8',
          ),
          const SizedBox(height: 12),
          const KeluargaCard(
            namaKeluarga: 'Keluarga Andi Wijaya',
            kepalaKeluarga: 'Andi Wijaya',
            jumlahAnggota: 5,
            alamat: 'Jl. Anggrek No. 15',
          ),
        ],
      ),
    );
  }
}
