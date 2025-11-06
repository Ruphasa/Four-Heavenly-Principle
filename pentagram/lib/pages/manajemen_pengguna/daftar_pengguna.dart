import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/pages/manajemen_pengguna/tambah_pengguna.dart';
import 'package:pentagram/providers/app_providers.dart';

class DaftarPenggunaPage extends ConsumerStatefulWidget {
  DaftarPenggunaPage({super.key});

  final List<Map<String, String>> dataPengguna = [
    {'no': '1', 'nama': 'Budi Santoso', 'email': 'budi@gmail.com', 'status': 'Diterima'},
    {'no': '2', 'nama': 'Siti Aminah', 'email': 'siti@gmail.com', 'status': 'Menunggu'},
    {'no': '3', 'nama': 'Rizky Ananda', 'email': 'rizky@gmail.com', 'status': 'Diterima'},
    {'no': '4', 'nama': 'Dewi Lestari', 'email': 'dewi@gmail.com', 'status': 'Ditolak'},
    {'no': '5', 'nama': 'Ahmad Fauzi', 'email': 'ahmad@gmail.com', 'status': 'Menunggu'},
    {'no': '6', 'nama': 'Nadya Pratama', 'email': 'nadya@gmail.com', 'status': 'Diterima'},
    {'no': '7', 'nama': 'Fajar Nugroho', 'email': 'fajar@gmail.com', 'status': 'Ditolak'},
    {'no': '8', 'nama': 'Citra Permata', 'email': 'citra@gmail.com', 'status': 'Diterima'},
    {'no': '9', 'nama': 'Ilham Saputra', 'email': 'ilham@gmail.com', 'status': 'Menunggu'},
    {'no': '10', 'nama': 'Dina Kusuma', 'email': 'dina@gmail.com', 'status': 'Diterima'},
    {'no': '11', 'nama': 'Rahmat Hidayat', 'email': 'rahmat@gmail.com', 'status': 'Menunggu'},
    {'no': '12', 'nama': 'Laila Rahma', 'email': 'laila@gmail.com', 'status': 'Diterima'},
    {'no': '13', 'nama': 'Teguh Prasetyo', 'email': 'teguh@gmail.com', 'status': 'Ditolak'},
    {'no': '14', 'nama': 'Yulia Kartika', 'email': 'yulia@gmail.com', 'status': 'Menunggu'},
    {'no': '15', 'nama': 'Anton Wijaya', 'email': 'anton@gmail.com', 'status': 'Diterima'},
    {'no': '16', 'nama': 'Bella Puspita', 'email': 'bella@gmail.com', 'status': 'Ditolak'},
    {'no': '17', 'nama': 'Hendra Gunawan', 'email': 'hendra@gmail.com', 'status': 'Menunggu'},
    {'no': '18', 'nama': 'Maya Lestari', 'email': 'maya@gmail.com', 'status': 'Diterima'},
    {'no': '19', 'nama': 'Reza Aditya', 'email': 'reza@gmail.com', 'status': 'Menunggu'},
    {'no': '20', 'nama': 'Intan Permata', 'email': 'intan@gmail.com', 'status': 'Diterima'},
  ];

  @override
  ConsumerState<DaftarPenggunaPage> createState() => _DaftarPenggunaPageState();
}

class _DaftarPenggunaPageState extends ConsumerState<DaftarPenggunaPage> {
  @override
  void initState() {
    super.initState();
    // Listen for errors and trigger initial refresh
    Future.microtask(() {
      ref.listen(manajemenPenggunaControllerProvider, (prev, next) {
        final msg = next.error;
        if (msg != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
          );
        }
      });
      ref.read(manajemenPenggunaControllerProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.dataPengguna.length,
                  itemBuilder: (context, index) {
                    final data = widget.dataPengguna[index];
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
                            data['no']!,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          data['nama']!,
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
                              data['email']!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                color: _statusColor(data['status']!),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: Text(
                                data['status']!,
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
                              _showDetailDialog(context, data);
                            } else if (value == 'hapus') {
                              _showDeleteDialog(context, data);
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
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Filter Manajemen Pengguna',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
                hintText: 'Cari nama...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              hint: const Text('-- Pilih Status --'),
              items: const [
                DropdownMenuItem(value: 'Diterima', child: Text('Diterima')),
                DropdownMenuItem(value: 'Ditolak', child: Text('Ditolak')),
                DropdownMenuItem(value: 'Menunggu', child: Text('Menunggu')),
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
            ),
            child: const Text('Reset Filter'),
          ),
          ElevatedButton(
            onPressed: () {
              // Apply filters (placeholder) and trigger refresh
              ref.read(manajemenPenggunaControllerProvider.notifier).refresh();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, Map<String, String> data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Detail Pengguna'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${data['nama']}'),
            Text('Email: ${data['email']}'),
            Text('Status: ${data['status']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, String> data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Pengguna'),
        content: Text('Apakah kamu yakin ingin menghapus ${data['nama']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
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
            ),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
