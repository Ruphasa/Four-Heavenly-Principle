import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/widgets/masyarakat/rumah_card.dart';

class RumahTab extends StatelessWidget {
  const RumahTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
      child: Column(
        children: [
          const RumahCard(
            alamat: 'Jl. Mawar No. 12',
            rt: '08',
            rw: '03',
            kepalaKeluarga: 'Ahmad Subarjo',
            status: 'Ditempati',
            statusColor: AppColors.success,
          ),
          const SizedBox(height: 12),
          const RumahCard(
            alamat: 'Jl. Melati No. 8',
            rt: '08',
            rw: '03',
            kepalaKeluarga: 'Budi Santoso',
            status: 'Ditempati',
            statusColor: AppColors.success,
          ),
          const SizedBox(height: 12),
          const RumahCard(
            alamat: 'Jl. Anggrek No. 15',
            rt: '08',
            rw: '03',
            kepalaKeluarga: 'Andi Wijaya',
            status: 'Ditempati',
            statusColor: AppColors.success,
          ),
          const SizedBox(height: 12),
          const RumahCard(
            alamat: 'Jl. Dahlia No. 20',
            rt: '08',
            rw: '03',
            kepalaKeluarga: '-',
            status: 'Kosong',
            statusColor: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
