import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/pages/masyarakat/tambah_warga_page.dart';
import 'package:pentagram/pages/masyarakat/tambah_keluarga_page.dart';
import 'package:pentagram/pages/masyarakat/tambah_rumah_page.dart';
import 'package:pentagram/pages/masyarakat/tabs/warga_tab.dart';
import 'package:pentagram/pages/masyarakat/tabs/keluarga_tab.dart';
import 'package:pentagram/pages/masyarakat/tabs/rumah_tab.dart';

class MasyarakatPage extends ConsumerStatefulWidget {
  const MasyarakatPage({super.key});

  @override
  ConsumerState<MasyarakatPage> createState() => _MasyarakatPageState();
}

class _MasyarakatPageState extends ConsumerState<MasyarakatPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Refresh FAB when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onFabPressed() {
    switch (_tabController.index) {
      case 0: // Warga
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TambahWargaPage(),
          ),
        );
        break;
      case 1: // Keluarga
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TambahKeluargaPage(),
          ),
        );
        break;
      case 2: // Rumah
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TambahRumahPage(),
          ),
        );
        break;
    }
  }

  // Removed FAB label/icon variants to follow '+' only guideline

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          title: const Text(
            'Data Masyarakat',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.textOnPrimary,
            labelColor: AppColors.textOnPrimary,
            unselectedLabelColor: AppColors.textOnPrimary.withValues(alpha: 0.7),
            tabs: const [
              Tab(text: 'Warga'),
              Tab(text: 'Keluarga'),
              Tab(text: 'Rumah'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            WargaTab(),
            KeluargaTab(),
            RumahTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onFabPressed,
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: AppColors.textOnPrimary),
        ),
      ),
    );
  }
}
