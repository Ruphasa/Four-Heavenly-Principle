import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/providers/app_providers.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';
import 'package:pentagram/pages/mutasi_keluarga/tambah_page.dart';
import 'package:pentagram/pages/mutasi_keluarga/detail_page.dart';

class DaftarMutasiPage extends ConsumerStatefulWidget {
  DaftarMutasiPage({super.key});

  @override
  ConsumerState<DaftarMutasiPage> createState() => _DaftarMutasiPageState();
}

class _DaftarMutasiPageState extends ConsumerState<DaftarMutasiPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      ref.listen(mutasiKeluargaControllerProvider, (prev, next) {
        final error = next.error;
        if (error != null && error.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mutasi Keluarga error: $error')),
          );
        }
      });
      await ref.read(mutasiKeluargaControllerProvider.notifier).refresh();
    });
  }

  final List<Map<String, String>> dataMutasi = [
    {
      'no': '1',
      'tanggal': '15 Oktober 2025',
      'keluarga': 'Keluarga Ijat',
      'jenis': 'Keluar Wilayah',
      'alamatLama': 'Jl. Mawar No. 12',
      'alamatBaru': '-',
      'alasan': 'Karena mau keluar',
    },
    {
      'no': '2',
      'tanggal': '30 September 2025',
      'keluarga': 'Keluarga Mara Nunez',
      'jenis': 'Pindah Rumah',
      'alamatLama': 'Jl. Melati No. 7',
      'alamatBaru': 'Jl. Kenanga No. 5',
      'alasan': 'Pindah rumah baru',
    },
  ];

  void _showFilterDialog(BuildContext context) {
    final responsive = context.responsive;
    String? selectedStatus;
    String? selectedKeluarga;

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
                    labelText: 'Status',
                    labelStyle: TextStyle(fontSize: responsive.fontSize(14)),
                    border: const OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: responsive.fontSize(14), color: Colors.black),
                  value: selectedStatus,
                  items: const [
                    DropdownMenuItem(value: 'Pindah Rumah', child: Text('Pindah Rumah')),
                    DropdownMenuItem(value: 'Keluar Wilayah', child: Text('Keluar Wilayah')),
                  ],
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
                  items: dataMutasi.map((data) {
                    return DropdownMenuItem(
                      value: data['keluarga'],
                      child: Text(data['keluarga']!),
                    );
                  }).toList(),
                  onChanged: (value) => selectedKeluarga = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Reset Filter',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
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
            onPressed: () => _showFilterDialog(context),
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
                        'Total: ${dataMutasi.length}',
                        style: TextStyle(
                          fontSize: responsive.fontSize(12),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                ...dataMutasi.map((data) {
                  final isPindah = data['jenis'] == 'Pindah Rumah';
                  final Color badgeBase = isPindah ? Colors.green : Colors.red;
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
                            builder: (context) => DetailMutasiPage(data: data),
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
                                data['no']!,
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
                                          data['keluarga']!,
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
                                          data['jenis']!,
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
                                          data['tanggal']!,
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
                                  if ((data['alamatLama'] ?? '').isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: responsive.spacing(6)),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.home_outlined, size: responsive.iconSize(14), color: Colors.grey[600]),
                                          SizedBox(width: responsive.spacing(6)),
                                          Expanded(
                                            child: Text(
                                              'Dari: ${data['alamatLama']!}',
                                              style: TextStyle(
                                                fontSize: responsive.fontSize(12),
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if ((data['alamatBaru'] ?? '').isNotEmpty && data['alamatBaru'] != '-')
                                    Padding(
                                      padding: EdgeInsets.only(top: responsive.spacing(4)),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.location_on_outlined, size: responsive.iconSize(14), color: Colors.grey[600]),
                                          SizedBox(width: responsive.spacing(6)),
                                          Expanded(
                                            child: Text(
                                              'Ke: ${data['alamatBaru']!}',
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
                }).toList(),
              ],
            ),
          ),
        ),
      ),

      // Tombol Tambah
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahMutasiPage()),
          ).then((_) async {
            await ref.read(mutasiKeluargaControllerProvider.notifier).refresh();
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: responsive.iconSize(28),
        ),
      ),
    );
  }
}
