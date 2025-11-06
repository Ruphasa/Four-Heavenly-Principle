import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/providers/app_providers.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/pages/pesan/pesan_warga_page.dart';
import 'package:pentagram/pages/log_aktivitas/log_aktivitas_page.dart';

class Notifikasi extends ConsumerStatefulWidget {
  const Notifikasi({super.key});

  @override
  ConsumerState<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends ConsumerState<Notifikasi>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final GlobalKey _pesanKey = GlobalKey();
  final GlobalKey _logKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() async {
      await ref.read(notifikasiControllerProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onFilter() {
    if (_tabController.index == 0) {
      final state = _pesanKey.currentState;
      (state as dynamic)?.openFilter?.call();
    } else {
      final state = _logKey.currentState;
      (state as dynamic)?.openFilter?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Error listener must be inside build
    ref.listen(notifikasiControllerProvider, (prev, next) {
      final error = next.error;
      if (error != null && error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notifikasi error: $error')),
        );
      }
    });
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Notifikasi'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.textOnPrimary, // active tab text color (white)
          unselectedLabelColor: Colors.black, // inactive tab text color (black)
          indicatorColor: AppColors.textOnPrimary,
          tabs: const [
            Tab(text: 'Pesan'),
            Tab(text: 'Log Aktivitas'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: 'Filter',
            onPressed: _onFilter,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PesanWargaPage(key: _pesanKey, embedded: true),
          LogAktivitasPage(key: _logKey, embedded: true),
        ],
      ),
    );
  }
}