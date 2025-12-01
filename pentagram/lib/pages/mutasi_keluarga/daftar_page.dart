import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pentagram/models/family_mutation.dart';
import 'package:pentagram/pages/mutasi_keluarga/detail_page.dart';
import 'package:pentagram/pages/mutasi_keluarga/tambah_page.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';

class DaftarMutasiPage extends ConsumerStatefulWidget {
  const DaftarMutasiPage({super.key});

  @override
  ConsumerState<DaftarMutasiPage> createState() => _DaftarMutasiPageState();
}

class _DaftarMutasiPageState extends ConsumerState<DaftarMutasiPage> {
  String? _statusFilter;
  String? _familyFilter;
  final DateFormat _dateFormatter = DateFormat('d MMMM yyyy');

  void _showFilterDialog(BuildContext context, List<FamilyMutation> data) {
    final responsive = context.responsive;
    String? selectedStatus = _statusFilter;
    String? selectedKeluarga = _familyFilter;
    final statuses = data.map((m) => m.type).toSet().toList()..sort();
    final families = data.map((m) => m.family).toSet().toList()..sort();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
          ),
          title: Text(
            'Filter Mutasi Keluarga',
            style: TextStyle(fontSize: responsive.fontSize(18)),
          ),
          content: SizedBox(
            width: responsive.responsive<double>(
              mobile: MediaQuery.of(context).size.width * 0.8,
              tablet: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Jenis Mutasi',
                    labelStyle: TextStyle(fontSize: responsive.fontSize(14)),
                    border: const OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: responsive.fontSize(14), color: Colors.black),
                  value: selectedStatus,
                  items: statuses
                      .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                  onChanged: (value) => selectedStatus = value,
                ),
                SizedBox(height: responsive.spacing(16)),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Keluarga',
                    labelStyle: TextStyle(fontSize: responsive.fontSize(14)),
                    border: const OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: responsive.fontSize(14), color: Colors.black),
                  value: selectedKeluarga,
                  items: families
                      .map((family) => DropdownMenuItem(value: family, child: Text(family)))
                      .toList(),
                  onChanged: (value) => selectedKeluarga = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _statusFilter = null;
                  _familyFilter = null;
                });
                Navigator.pop(context);
              },
              child: Text(
                'Reset Filter',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _statusFilter = selectedStatus;
                  _familyFilter = selectedKeluarga;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.padding(16),
                  vertical: responsive.padding(10),
                ),
              ),
              child: Text(
                'Terapkan',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final mutationsAsync = ref.watch(familyMutationsStreamProvider);

    return mutationsAsync.when(
      data: (mutations) {
        final filtered = _applyFilters(mutations);
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            title: Text(
              'Daftar Mutasi Keluarga',
              style: TextStyle(fontSize: responsive.fontSize(18)),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.filter_list, size: responsive.iconSize(20)),
                tooltip: 'Filter',
                onPressed: () => _showFilterDialog(context, mutations),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(responsive.padding(24)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: responsive.elevation(6),
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.padding(16),
                        vertical: responsive.padding(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daftar Mutasi',
                            style: TextStyle(
                              fontSize: responsive.fontSize(18),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Total: ${filtered.length}',
                            style: TextStyle(
                              fontSize: responsive.fontSize(12),
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (filtered.isEmpty)
                      Padding(
                        padding: EdgeInsets.all(responsive.padding(24)),
                        child: Column(
                          children: [
                            Icon(Icons.inbox_outlined, size: responsive.iconSize(40), color: AppColors.textMuted),
                            SizedBox(height: responsive.spacing(8)),
                            const Text('Belum ada data sesuai filter'),
                          ],
                        ),
                      )
                    else
                      ...filtered.map((mutation) => _buildMutationTile(context, responsive, mutation)).toList(),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF6C63FF),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TambahMutasiPage()),
              );
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: responsive.iconSize(28),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Gagal memuat data: $error',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<FamilyMutation> _applyFilters(List<FamilyMutation> mutations) {
    return mutations.where((mutation) {
      final statusOk = _statusFilter == null || mutation.type == _statusFilter;
      final familyOk = _familyFilter == null || mutation.family == _familyFilter;
      return statusOk && familyOk;
    }).toList();
  }

  Widget _buildMutationTile(BuildContext context, ResponsiveHelper responsive, FamilyMutation mutation) {
    final isPindah = mutation.type.toLowerCase().contains('pindah');
    final badgeBase = isPindah ? Colors.green : Colors.red;

    return Padding(
      padding: EdgeInsets.only(
        left: responsive.padding(16),
        right: responsive.padding(16),
        bottom: responsive.spacing(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailMutasiPage(mutation: mutation),
            ),
          );
        },
        borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(responsive.padding(14)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: responsive.iconSize(36),
                height: responsive.iconSize(36),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  mutation.no.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.fontSize(12),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            mutation.family,
                            style: TextStyle(
                              fontSize: responsive.fontSize(14),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.padding(10),
                            vertical: responsive.padding(4),
                          ),
                          decoration: BoxDecoration(
                            color: badgeBase.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
                          ),
                          child: Text(
                            mutation.type,
                            style: TextStyle(
                              color: isPindah ? Colors.green.shade700 : Colors.red.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: responsive.fontSize(11),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.spacing(6)),
                    Row(
                      children: [
                        Icon(Icons.event, size: responsive.iconSize(14), color: Colors.grey[600]),
                        SizedBox(width: responsive.spacing(6)),
                        Expanded(
                          child: Text(
                            _dateFormatter.format(mutation.date),
                            style: TextStyle(
                              fontSize: responsive.fontSize(12),
                              color: Colors.grey[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (mutation.oldAddress.isNotEmpty && mutation.oldAddress != '-')
                      Padding(
                        padding: EdgeInsets.only(top: responsive.spacing(6)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.home_outlined, size: responsive.iconSize(14), color: Colors.grey[600]),
                            SizedBox(width: responsive.spacing(6)),
                            Expanded(
                              child: Text(
                                'Dari: ${mutation.oldAddress}',
                                style: TextStyle(
                                  fontSize: responsive.fontSize(12),
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (mutation.newAddress.isNotEmpty && mutation.newAddress != '-')
                      Padding(
                        padding: EdgeInsets.only(top: responsive.spacing(4)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on_outlined, size: responsive.iconSize(14), color: Colors.grey[600]),
                            SizedBox(width: responsive.spacing(6)),
                            Expanded(
                              child: Text(
                                'Ke: ${mutation.newAddress}',
                                style: TextStyle(
                                  fontSize: responsive.fontSize(12),
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
