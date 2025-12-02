import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/providers/app_providers.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/models/penerimaan_warga.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/widgets/penerimaan/penerimaan_card.dart';
import 'package:pentagram/widgets/penerimaan/filter_penerimaan_warga.dart';
import 'package:pentagram/pages/penerimaan_warga/penerimaan_warga_detail.dart';

class PenerimaanWargaPage extends ConsumerStatefulWidget {
  const PenerimaanWargaPage({super.key});

  @override
  ConsumerState<PenerimaanWargaPage> createState() => _PenerimaanWargaPageState();
}

class _PenerimaanWargaPageState extends ConsumerState<PenerimaanWargaPage> {
  final TextEditingController _searchController = TextEditingController();
  String selectedStatus = 'Semua';
  String selectedGender = 'Semua';

  List<PenerimaanWarga> _applyFilters(List<PenerimaanWarga> list) {
    final filtered = list.where((w) {
      final matchesGender =
          selectedGender == 'Semua' || w.jenisKelamin == selectedGender;
      final matchesStatus =
          selectedStatus == 'Semua' || w.statusRegistrasi == selectedStatus;
      final q = _searchController.text.trim().toLowerCase();
      final matchesSearch = q.isEmpty || w.nama.toLowerCase().contains(q);
      return matchesGender && matchesStatus && matchesSearch;
    }).toList();
    filtered.sort((a, b) => a.no.compareTo(b.no));
    return filtered;
  }

  void _showGenderFilter() {
    showDialog(
      context: context,
      builder: (_) => FilterPenerimaanWargaDialog(
        selectedGender: selectedGender,
        onFilterSelected: (label) {
          setState(() => selectedGender = label);
          // Nudge provider on filter changes
          ref.read(penerimaanWargaControllerProvider.notifier).refresh();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initial refresh is fine here
    Future.microtask(() async {
      await ref.read(penerimaanWargaControllerProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Error listener must be inside build
    ref.listen(penerimaanWargaControllerProvider, (prev, next) {
      final error = next.error;
      if (error != null && error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Penerimaan Warga error: $error')),
        );
      }
    });
    final wargaAsync = ref.watch(penerimaanWargaStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Penerimaan Warga'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showGenderFilter,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatusFilterChips(),
          Expanded(
            child: wargaAsync.when(
              data: (list) {
                final filteredList = _applyFilters(list);
                if (filteredList.isEmpty) {
                  return const Center(child: Text('Tidak ada data'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final warga = filteredList[index];
                    return PenerimaanCard(
                      warga: warga,
                      onTap: () => DetailPenerimaanWargaOverlay.show(context, warga),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Gagal memuat: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
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
            hintText: 'Cari nama warga...',
            hintStyle: TextStyle(color: AppColors.textMuted),
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.iconPrimary),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onChanged: (_) => setState(() {}),
          // Optional: tell provider to refresh for search-driven views
          // ignore: avoid_redundant_argument_values
          // (kept minimal to avoid heavy refreshes on each keystroke)
        ),
      ),
    );
  }

  Widget _buildStatusFilterChips() {
    final statuses = ['Semua', 'Pending', 'Diterima', 'Ditolak'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: statuses.map((status) {
          final isSelected = selectedStatus == status;
          return GestureDetector(
            onTap: () {
              setState(() => selectedStatus = status);
              ref.read(penerimaanWargaControllerProvider.notifier).refresh();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.textOnPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
