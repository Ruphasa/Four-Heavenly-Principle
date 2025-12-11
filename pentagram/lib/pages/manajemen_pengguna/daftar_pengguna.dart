import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';
import 'package:pentagram/pages/manajemen_pengguna/tambah_pengguna.dart';
import 'package:pentagram/providers/app_providers.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/widgets/manajemen_pengguna/user_card.dart';

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
        elevation: 0,
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final usersAsync = ref.watch(usersStreamProvider);
          
          return usersAsync.when(
            data: (users) {
              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 80,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada pengguna',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return UserCard(
                    user: user,
                    onTap: () => _showDetailDialog(context, ref, user),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat data',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
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

  void _showDetailDialog(BuildContext context, WidgetRef ref, user) {
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
                'Nama: ${user.name}',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
              SizedBox(height: responsive.spacing(4)),
              Text(
                'Email: ${user.email}',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
              SizedBox(height: responsive.spacing(4)),
              if (user.phone != null && user.phone!.isNotEmpty)
                Text(
                  'Telepon: ${user.phone}',
                  style: TextStyle(fontSize: responsive.fontSize(14)),
                ),
              if (user.phone != null && user.phone!.isNotEmpty)
                SizedBox(height: responsive.spacing(4)),
              Text(
                'Status: ${user.status}',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
            ],
          ),
          actions: [
            // Tombol Hapus
            TextButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);
                _showDeleteDialog(context, user);
              },
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              label: Text(
                'Hapus',
                style: TextStyle(
                  fontSize: responsive.fontSize(14),
                  color: AppColors.error,
                ),
              ),
            ),
            
            // Tombol Tolak (hanya untuk status Menunggu)
            if (user.status == 'Menunggu')
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _showRejectDialog(context, user);
                },
                icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
                label: Text(
                  'Tolak',
                  style: TextStyle(
                    fontSize: responsive.fontSize(14),
                    color: AppColors.error,
                  ),
                ),
              ),
            
            // Tombol Setujui (hanya untuk status Menunggu)
            if (user.status == 'Menunggu')
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _showApproveDialog(context, user);
                },
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: Text(
                  'Setujui',
                  style: TextStyle(fontSize: responsive.fontSize(14)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
              ),
            
            // Tombol Tutup
            if (user.status != 'Menunggu')
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
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

  void _showDeleteDialog(BuildContext context, user) {
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
            'Apakah kamu yakin ingin menghapus ${user.name}?',
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
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final userRepo = ref.read(userRepositoryProvider);
                  await userRepo.delete(user.documentId!);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${user.name} telah dihapus'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal menghapus: $e'),
                        backgroundColor: AppColors.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
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

  void _showApproveDialog(BuildContext context, user) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final responsive = dialogContext.responsive;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
          ),
          title: const Text('Setujui Pengguna'),
          content: Text('Apakah Anda yakin ingin menyetujui ${user.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final userRepo = ref.read(userRepositoryProvider);
                  await userRepo.collection.doc(user.documentId).set(
                    {'status': 'Disetujui'},
                    SetOptions(merge: true),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${user.name} telah disetujui'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal menyetujui: $e'),
                        backgroundColor: AppColors.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Setujui', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showRejectDialog(BuildContext context, user) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final responsive = dialogContext.responsive;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
          ),
          title: const Text('Tolak Pengguna'),
          content: Text('Apakah Anda yakin ingin menolak ${user.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final userRepo = ref.read(userRepositoryProvider);
                  await userRepo.collection.doc(user.documentId).set(
                    {'status': 'Ditolak'},
                    SetOptions(merge: true),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${user.name} telah ditolak'),
                        backgroundColor: AppColors.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal menolak: $e'),
                        backgroundColor: AppColors.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Tolak', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
