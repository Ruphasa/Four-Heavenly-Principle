import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';
import 'package:pentagram/pages/manajemen_pengguna/tambah_pengguna.dart';
import 'package:pentagram/providers/app_providers.dart';
import 'package:pentagram/providers/firestore_providers.dart';

class DaftarPenggunaPage extends ConsumerStatefulWidget {
  DaftarPenggunaPage({super.key});

  @override
  ConsumerState<DaftarPenggunaPage> createState() => _DaftarPenggunaPageState();
}

class _DaftarPenggunaPageState extends ConsumerState<DaftarPenggunaPage> {
  @override
  void initState() {
    super.initState();
    // Trigger initial refresh only
    Future.microtask(() {
      ref.read(manajemenPenggunaControllerProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for errors inside build
    ref.listen(manajemenPenggunaControllerProvider, (prev, next) {
      final msg = next.error;
      if (msg != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
        );
      }
    });
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: const Text('Manajemen Pengguna'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar Pengguna',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // List pengguna
                Consumer(builder: (context, ref, _) {
                  final usersAsync = ref.watch(usersStreamProvider);
                  return usersAsync.when(
                    data: (users) => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                          child: Text(
                                '${index + 1}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                              user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                                  user.email,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                    color: _statusColor(user.status),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: Text(
                                    user.status,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onSelected: (value) {
                            if (value == 'detail') {
                                  _showDetailDialog(context, {
                                    'nama': user.name,
                                    'email': user.email,
                                    'status': user.status,
                                  });
                            } else if (value == 'hapus') {
                                  _showDeleteDialog(context, {
                                    'nama': user.name,
                                    'email': user.email,
                                  });
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'detail',
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, size: 18),
                                  SizedBox(width: 8),
                                  Text('Detail'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'hapus',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline, size: 18),
                                  SizedBox(width: 8),
                                  Text('Hapus'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Gagal memuat: $e')),
                  );
                }),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahPenggunaPage()),
          ).then((_) {
            if (mounted) {
              ref.read(manajemenPenggunaControllerProvider.notifier).refresh();
            }
          });
        },
        child: Builder(
          builder: (context) {
            final screenWidth = MediaQuery.of(context).size.width;
            final isCompact = screenWidth < 400;
            return Icon(
              Icons.add,
              color: Colors.white,
              size: isCompact ? 24 : 28,
            );
          },
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Diterima':
        return Colors.green.shade100;
      case 'Ditolak':
        return Colors.red.shade100;
      case 'Menunggu':
        return Colors.yellow.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  void _showFilterDialog(BuildContext context) {
    final TextEditingController namaController = TextEditingController();
    // ignore: unused_local_variable
    String? selectedStatus;

    showDialog(
      context: context,
      builder: (dialogContext) {
        final responsive = dialogContext.responsive;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
          ),
          titlePadding: EdgeInsets.fromLTRB(
            responsive.padding(20),
            responsive.padding(20),
            responsive.padding(20),
            responsive.padding(12),
          ),
          contentPadding: EdgeInsets.fromLTRB(
            responsive.padding(20),
            0,
            responsive.padding(20),
            responsive.padding(12),
          ),
          actionsPadding: EdgeInsets.fromLTRB(
            responsive.padding(20),
            0,
            responsive.padding(20),
            responsive.padding(16),
          ),
          title: Text(
            'Filter Pengguna',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: responsive.fontSize(16),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                style: TextStyle(fontSize: responsive.fontSize(14)),
                decoration: InputDecoration(
                  labelText: 'Nama',
                  labelStyle: TextStyle(fontSize: responsive.fontSize(13)),
                  hintText: 'Cari nama...',
                  hintStyle: TextStyle(fontSize: responsive.fontSize(13)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: responsive.padding(12),
                    vertical: responsive.padding(12),
                  ),
                ),
              ),
              SizedBox(height: responsive.spacing(12)),
              DropdownButtonFormField<String>(
                style: TextStyle(fontSize: responsive.fontSize(14)),
                decoration: InputDecoration(
                  labelText: 'Status',
                  labelStyle: TextStyle(fontSize: responsive.fontSize(13)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: responsive.padding(12),
                    vertical: responsive.padding(12),
                  ),
                ),
                hint: Text(
                  '-- Pilih Status --',
                  style: TextStyle(fontSize: responsive.fontSize(13)),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Diterima',
                    child: Text(
                      'Diterima',
                      style: TextStyle(fontSize: responsive.fontSize(14)),
                    ),
                ),
                  DropdownMenuItem(
                    value: 'Ditolak',
                    child: Text(
                      'Ditolak',
                      style: TextStyle(fontSize: responsive.fontSize(14)),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Menunggu',
                    child: Text(
                      'Menunggu',
                      style: TextStyle(fontSize: responsive.fontSize(14)),
                    ),
                  ),
                ],
                onChanged: (value) {
                  selectedStatus = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                namaController.clear();
                selectedStatus = null;
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade800,
                backgroundColor: Colors.grey.shade200,
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.padding(12),
                  vertical: responsive.padding(8),
                ),
              ),
              child: Text(
                'Reset',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Apply filters (placeholder) and trigger refresh
                ref.read(manajemenPenggunaControllerProvider.notifier).refresh();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.padding(12),
                  vertical: responsive.padding(8),
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

  void _showDetailDialog(BuildContext context, Map<String, String> data) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final responsive = dialogContext.responsive;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
          ),
          titlePadding: EdgeInsets.fromLTRB(
            responsive.padding(20),
            responsive.padding(20),
            responsive.padding(20),
            responsive.padding(12),
          ),
          contentPadding: EdgeInsets.fromLTRB(
            responsive.padding(20),
            0,
            responsive.padding(20),
            responsive.padding(12),
          ),
          actionsPadding: EdgeInsets.fromLTRB(
            responsive.padding(20),
            0,
            responsive.padding(20),
            responsive.padding(16),
          ),
          title: Text(
            'Detail Pengguna',
            style: TextStyle(
              fontSize: responsive.fontSize(16),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nama: ${data['nama']}',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
              SizedBox(height: responsive.spacing(4)),
              Text(
                'Email: ${data['email']}',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
              SizedBox(height: responsive.spacing(4)),
              Text(
                'Status: ${data['status']}',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Tutup',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, String> data) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final responsive = dialogContext.responsive;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
          ),
          titlePadding: EdgeInsets.fromLTRB(
            responsive.padding(20),
            responsive.padding(20),
            responsive.padding(20),
            responsive.padding(12),
          ),
          contentPadding: EdgeInsets.fromLTRB(
            responsive.padding(20),
            0,
            responsive.padding(20),
            responsive.padding(12),
          ),
          actionsPadding: EdgeInsets.fromLTRB(
            responsive.padding(20),
            0,
            responsive.padding(20),
            responsive.padding(16),
          ),
          title: Text(
            'Hapus Pengguna',
            style: TextStyle(
              fontSize: responsive.fontSize(16),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus ${data['nama']}?',
            style: TextStyle(fontSize: responsive.fontSize(14)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${data['nama']} telah dihapus'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                // Trigger a refresh after deletion
                ref.read(manajemenPenggunaControllerProvider.notifier).refresh();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.padding(12),
                  vertical: responsive.padding(8),
                ),
              ),
              child: Text(
                'Hapus',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: responsive.fontSize(14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
