import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/widgets/masyarakat/masyarakat_filter_chip.dart';
import 'package:pentagram/widgets/masyarakat/warga_card.dart';

class WargaTab extends StatefulWidget {
  const WargaTab({super.key});

  @override
  State<WargaTab> createState() => _WargaTabState();
}

class _WargaTabState extends State<WargaTab> {
  String _selectedFilter = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          const WargaCard(
            name: 'Ahmad Subarjo',
            nik: '3201012345678901',
            role: 'Kepala Keluarga',
            status: 'Aktif',
            statusColor: AppColors.success,
          ),
          const SizedBox(height: 12),
          const WargaCard(
            name: 'Siti Nurhaliza',
            nik: '3201012345678902',
            role: 'Istri',
            status: 'Aktif',
            statusColor: AppColors.success,
          ),
          const SizedBox(height: 12),
          const WargaCard(
            name: 'Budi Santoso',
            nik: '3201012345678903',
            role: 'Kepala Keluarga',
            status: 'Aktif',
            statusColor: AppColors.success,
          ),
          const SizedBox(height: 12),
          const WargaCard(
            name: 'Dewi Lestari',
            nik: '3201012345678904',
            role: 'Anak',
            status: 'Tidak Aktif',
            statusColor: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
