import 'package:flutter/material.dart';
import 'package:pentagram/pages/dashboard/dashboard.dart';
import 'package:pentagram/pages/activity_broadcast/activity_view.dart';
import 'package:pentagram/pages/keuangan/keuangan_page.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/pages/masyarakat/masyarakat_page.dart';
// Removed NotificationsPage import; using existing Notifikasi page via Dashboard entry

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const Dashboard(),
    const ActivityView(),
    const KeuanganPage(),
    const MasyarakatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 400;
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
  // Floating Pesan removed per UX; no FAB here
  floatingActionButton: null,
  floatingActionButtonLocation: null,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth / 4 * 0.2,
              vertical: isCompact ? 6 : 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  index: 0,
                  isCompact: isCompact,
                ),
                _buildNavItem(
                  icon: Icons.campaign_rounded,
                  label: 'Kegiatan',
                  index: 1,
                  isCompact: isCompact,
                ),
                _buildNavItem(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Keuangan',
                  index: 2,
                  isCompact: isCompact,
                ),
                _buildNavItem(
                  icon: Icons.people_rounded,
                  label: 'Masyarakat',
                  index: 3,
                  isCompact: isCompact,
                ),
                // Notifikasi is accessible from Dashboard; no nav item here
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isCompact,
  }) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 8 : 16,
          vertical: isCompact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.textOnPrimary : AppColors.iconPrimary,
              size: isCompact ? 20 : 24,
            ),
            SizedBox(height: isCompact ? 2 : 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                fontSize: isCompact ? 9 : 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
