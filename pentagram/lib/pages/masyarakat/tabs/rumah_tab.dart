import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/widgets/masyarakat/rumah_card.dart';

class RumahTab extends ConsumerWidget {
  const RumahTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final housesAsync = ref.watch(housesStreamProvider);
    final familiesAsync = ref.watch(familiesStreamProvider);

    // Build a lookup map familyId -> family name for display.
    final families = familiesAsync.asData?.value ?? const [];
    final familyNameById = <String, String>{
      for (final family in families)
        if (family.documentId != null) family.documentId!: family.name,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
      child: housesAsync.when(
        data: (houses) {
          if (houses.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final house = houses[index];
              final namaKeluarga = house.familyId != null
                  ? (familyNameById[house.familyId] ?? house.familyName ?? '-')
                  : (house.familyName ?? '-');
              return RumahCard(
                alamat: house.address,
                rt: house.rt,
                rw: house.rw,
                namaKeluarga: namaKeluarga,
                status: house.status,
                statusColor: _statusColor(house.status),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: houses.length,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _buildErrorState(err),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'dihuni':
      case 'ditempati':
        return AppColors.success;
      case 'kosong':
        return AppColors.textSecondary;
      default:
        return AppColors.accent;
    }
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: const [
          Icon(Icons.home_outlined, color: AppColors.textMuted, size: 32),
          SizedBox(height: 12),
          Text(
            'Belum ada data rumah',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(height: 12),
          const Text(
            'Gagal memuat data rumah',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
