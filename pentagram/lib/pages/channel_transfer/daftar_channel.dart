import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/providers/app_providers.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/pages/channel_transfer/detail_channel_page.dart';
import 'package:pentagram/pages/channel_transfer/tambah_channel.dart'; // arah ke file lib/pages/channel_transfer/tambah_channel.dart

class DaftarChannelPage extends ConsumerStatefulWidget {
  const DaftarChannelPage({super.key});

  @override
  ConsumerState<DaftarChannelPage> createState() => _DaftarChannelPageState();
}

class _DaftarChannelPageState extends ConsumerState<DaftarChannelPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(channelTransferControllerProvider.notifier).refresh();
    });
  }

  

  @override
  Widget build(BuildContext context) {
    // Error listener (inside build)
    ref.listen(channelTransferControllerProvider, (prev, next) {
      final error = next.error;
      if (error != null && error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Channel Transfer error: $error')),
        );
      }
    });
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Daftar Channel Transfer',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),

      // === Tombol Tambah Channel ===
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahChannelPage(),
            ),
          ).then((_) async {
            await ref.read(channelTransferControllerProvider.notifier).refresh();
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

      // === Daftar Channel ===
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer(builder: (context, ref, _) {
          final channelsAsync = ref.watch(channelsStreamProvider);
          return channelsAsync.when(
            data: (channels) => ListView.builder(
              itemCount: channels.length,
              itemBuilder: (context, index) {
                final ch = channels[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                title: Text(
                  ch.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Tipe: ${ch.type}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      'A/N: ${ch.accountName}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                trailing: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailChannelPage(data: {
                          'nama': ch.name,
                          'tipe': ch.type,
                          'an': ch.accountName,
                          'thumbnail': ch.thumbnail ?? '',
                        }),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Detail',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios,
                          color: AppColors.primary, size: 16),
                    ],
                  ),
                ),
              ),
            );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Gagal memuat: $e')),
          );
        }),
      ),
    );
  }
}
