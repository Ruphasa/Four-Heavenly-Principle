import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/models/citizen.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/widgets/masyarakat/masyarakat_filter_chip.dart';
import 'package:pentagram/widgets/masyarakat/warga_card.dart';

class WargaTab extends ConsumerStatefulWidget {
  const WargaTab({super.key});

  @override
  ConsumerState<WargaTab> createState() => _WargaTabState();
}

class _WargaTabState extends ConsumerState<WargaTab> {
  String _selectedFilter = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final citizensAsync = ref.watch(citizensStreamProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Cari warga...',
                hintStyle: TextStyle(color: AppColors.textMuted),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.iconPrimary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                MasyarakatFilterChip(
                  label: 'Semua',
                  isSelected: _selectedFilter == 'Semua',
                  onTap: () => setState(() => _selectedFilter = 'Semua'),
                ),
                const SizedBox(width: 8),
                MasyarakatFilterChip(
                  label: 'Kepala Keluarga',
                  isSelected: _selectedFilter == 'Kepala Keluarga',
                  onTap: () => setState(() => _selectedFilter = 'Kepala Keluarga'),
                ),
                const SizedBox(width: 8),
                MasyarakatFilterChip(
                  label: 'Aktif',
                  isSelected: _selectedFilter == 'Aktif',
                  onTap: () => setState(() => _selectedFilter = 'Aktif'),
                ),
                const SizedBox(width: 8),
                MasyarakatFilterChip(
                  label: 'Tidak Aktif',
                  isSelected: _selectedFilter == 'Tidak Aktif',
                  onTap: () => setState(() => _selectedFilter = 'Tidak Aktif'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Warga List
          citizensAsync.when(
            data: (citizens) {
              final filtered = _filterCitizens(citizens);
              if (filtered.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final citizen = filtered[index];
                  return WargaCard(
                    name: citizen.name,
                    nik: citizen.nik,
                    role: citizen.familyRole,
                    status: citizen.status,
                    statusColor: _statusColor(citizen.status),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: filtered.length,
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.only(top: 32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => _buildErrorState(err),
          ),
        ],
      ),
    );
  }

  List<Citizen> _filterCitizens(List<Citizen> citizens) {
    final search = _searchController.text.trim().toLowerCase();
    return citizens.where((citizen) {
      final matchesSearch = search.isEmpty ||
          citizen.name.toLowerCase().contains(search) ||
          citizen.nik.toLowerCase().contains(search);

      final matchesFilter = switch (_selectedFilter) {
        'Kepala Keluarga' => citizen.familyRole.toLowerCase().contains('kepala'),
        'Aktif' => citizen.status.toLowerCase() == 'aktif',
        'Tidak Aktif' => citizen.status.toLowerCase() != 'aktif',
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();
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
          Icon(Icons.people_outline, color: AppColors.textMuted, size: 32),
          SizedBox(height: 12),
          Text(
            'Belum ada data warga',
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
          Text(
            'Gagal memuat data warga',
            style: const TextStyle(fontWeight: FontWeight.bold),
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

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return AppColors.success;
      case 'tidak aktif':
      case 'nonaktif':
        return AppColors.textSecondary;
      default:
        return AppColors.accent;
    }
  }
}
