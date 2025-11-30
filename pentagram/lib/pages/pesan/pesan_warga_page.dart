import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/providers/app_providers.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/models/pesan_warga.dart';
import 'package:pentagram/widgets/pesan/pesan_card.dart';
import 'package:pentagram/widgets/pesan/filter_pesan_dialog.dart';
import 'package:pentagram/pages/pesan/detail_pesan.dart';
import 'package:pentagram/providers/firestore_providers.dart';

class PesanWargaPage extends ConsumerStatefulWidget {
  final bool embedded;
  const PesanWargaPage({super.key, this.embedded = false});

  @override
  ConsumerState<PesanWargaPage> createState() => _PesanWargaPageState();
}

class _PesanWargaPageState extends ConsumerState<PesanWargaPage> {
  final TextEditingController _searchController = TextEditingController();
  String selectedFilter = 'Semua';

  // Firestore will be the source of truth via pesanStreamProvider

  @override
  void initState() {
    super.initState();
    // Initial refresh only
    Future.microtask(() {
      ref.read(pesanControllerProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterPesanDialog(
        selectedFilter: selectedFilter,
        onFilterSelected: (label) {
          setState(() => selectedFilter = label);
          ref.read(pesanControllerProvider.notifier).refresh();
        },
      ),
    );
  }

  // Exposed method for parent to open filter dialog
  void openFilter() => _showFilterDialog();

  @override
  Widget build(BuildContext context) {
    // Error listener must be inside build
    ref.listen(pesanControllerProvider, (prev, next) {
      final error = next.error;
      if (error != null && error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pesan error: $error')),
        );
      }
    });

    final pesanAsync = ref.watch(pesanStreamProvider);
    final filteredList = (pesanAsync.asData?.value ?? const <PesanWarga>[]).where((p) {
      if (selectedFilter == 'Belum Dibaca' && !p.unread) return false;
      if (selectedFilter == 'Sudah Dibaca' && p.unread) return false;
      return true;
    }).toList();

    final content = Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textOnPrimary),
              decoration: InputDecoration(
                hintText: 'Cari pesan...',
                hintStyle: TextStyle(color: AppColors.textOnPrimary.withValues(alpha: 0.7)),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textOnPrimary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: AppColors.textOnPrimary),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
          ),

          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Semua', Icons.all_inbox_rounded),
                  const SizedBox(width: 8),
                  _buildFilterChip('Belum Dibaca', Icons.mark_email_unread_rounded),
                  const SizedBox(width: 8),
                  _buildFilterChip('Sudah Dibaca', Icons.drafts_rounded),
                ],
              ),
            ),
          ),

          // Messages List
          Expanded(
            child: pesanAsync.when(
              data: (list) => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final pesan = filteredList[index];
                  return PesanCard(
                    pesan: pesan,
                    onTap: () {
                      DetailPesanOverlay.show(
                        context,
                        PesanWarga(
                          nama: pesan.nama,
                          pesan: pesan.pesan,
                          waktu: pesan.waktu,
                          unread: pesan.unread,
                          avatar: pesan.avatar,
                        ),
                      );
                    },
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      );

    if (widget.embedded) return content;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: const Text('Pesan Warga'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add_comment_rounded),
            tooltip: 'Tambah pesan contoh',
            onPressed: () async {
              final repo = ref.read(pesanRepositoryProvider);
              try {
                await repo.create(PesanWarga(
                  nama: 'Admin',
                  pesan: 'Halo warga, ini contoh pesan.',
                  waktu: 'now',
                  unread: true,
                  avatar: 'AD',
                ));
              } catch (e) {
                final msg = e.toString().contains('permission-denied')
                    ? 'Akses Firestore ditolak (permission-denied). Perbarui rules atau pastikan sudah login.'
                    : 'Gagal membuat pesan: $e';
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(msg)),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: content,
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.textOnPrimary : AppColors.iconPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}