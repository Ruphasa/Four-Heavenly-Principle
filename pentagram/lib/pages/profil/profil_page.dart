import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';
import 'package:pentagram/providers/app_providers.dart';
import 'package:pentagram/providers/auth_providers.dart';
import 'package:pentagram/providers/current_user_provider.dart';
import 'package:pentagram/pages/login/login_page.dart';
import 'package:pentagram/pages/profil/edit_profil_page.dart';
import 'package:pentagram/widgets/profil/profile_header.dart';
import 'package:pentagram/widgets/profil/profile_menu_section.dart';
import 'package:pentagram/widgets/profil/profile_menu_item.dart';
import 'package:pentagram/widgets/common/responsive_dialog.dart';

class ProfilPage extends ConsumerWidget {
  const ProfilPage({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ResponsiveConfirmDialog(
        title: 'Konfirmasi Logout',
        message: 'Apakah Anda yakin ingin keluar dari aplikasi?',
        confirmText: 'Logout',
        cancelText: 'Batal',
        icon: Icons.logout,
        iconColor: AppColors.error,
        confirmColor: AppColors.error,
      ),
    );

    if (shouldLogout != true) return;

    if (!context.mounted) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (loadingContext) {
        final responsive = loadingContext.responsive;
        return Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(responsive.padding(24)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: responsive.iconSize(40),
                    height: responsive.iconSize(40),
                    child: const CircularProgressIndicator(),
                  ),
                  SizedBox(height: responsive.spacing(16)),
                  Text(
                    'Logging out...',
                    style: TextStyle(fontSize: responsive.fontSize(14)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Perform logout
    await ref.read(authControllerProvider.notifier).logout();

    if (!context.mounted) return;

    // Close loading dialog
    Navigator.pop(context);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Anda telah logout.'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to login page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(profilControllerProvider, (prev, next) {
      final error = next.error;
      if (error != null && error.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Profil error: $error')));
      }
    });

    final asyncUser = ref.watch(currentAppUserProvider);
    final asyncUserName = ref.watch(currentUserNameProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: asyncUser.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        // Jika terjadi error (mis. permission-denied), tetap tampilkan profil
        // dengan fallback ke nama dari provider asyncUserName.
        error: (_, __) => SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              asyncUserName.when(
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const SizedBox.shrink(),
                data: (name) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: const ProfileHeader(
                    name: 'User',
                    role: 'User',
                    imagePath: 'assets/images/profile.png',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildActionButtons(context),
              const SizedBox(height: 24),
              ProfileMenuSection(
              title: 'PENGATURAN AKUN',
              children: [
                ProfileMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Ubah Password',
                  onTap: () {},
                ),
              ],
            ),
              const SizedBox(height: 16),
              ProfileMenuSection(
              title: 'BANTUAN & INFORMASI',
              children: [
                ProfileMenuItem(
                  icon: Icons.phone_outlined,
                  title: 'Pusat Bantuan',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.language,
                  title: 'Bahasa',
                  subtitle: 'Indonesia',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.info_outline,
                  title: 'Tentang Jawara Pintar',
                  onTap: () {},
                ),
              ],
            ),
              const SizedBox(height: 16),
              ProfileMenuSection(
              title: 'LAINNYA',
              children: [
                ProfileMenuItem(
                  icon: Icons.star_outline,
                  title: 'Beri Rating',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.article_outlined,
                  title: 'Ketentuan Layanan',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.shield_outlined,
                  title: 'Kebijakan Privasi',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  iconColor: AppColors.error,
                  onTap: () => _handleLogout(context, ref),
                ),
              ],
            ),
              const SizedBox(height: 24),
              _buildFooter(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
        data: (user) => SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              asyncUserName.when(
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const SizedBox.shrink(),
                data: (name) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ProfileHeader(
                    name: user?.name ?? name,
                    role: user?.status ?? 'User',
                    imagePath: 'assets/images/profile.png',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildActionButtons(context),
              const SizedBox(height: 24),
              ProfileMenuSection(
                title: 'PENGATURAN AKUN',
                children: [
                  ProfileMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Ubah Password',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ProfileMenuSection(
                title: 'BANTUAN & INFORMASI',
                children: [
                  ProfileMenuItem(
                    icon: Icons.phone_outlined,
                    title: 'Pusat Bantuan',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.language,
                    title: 'Bahasa',
                    subtitle: 'Indonesia',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.info_outline,
                    title: 'Tentang Jawara Pintar',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ProfileMenuSection(
                title: 'LAINNYA',
                children: [
                  ProfileMenuItem(
                    icon: Icons.star_outline,
                    title: 'Beri Rating',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.article_outlined,
                    title: 'Ketentuan Layanan',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.shield_outlined,
                    title: 'Kebijakan Privasi',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    iconColor: AppColors.error,
                    onTap: () => _handleLogout(context, ref),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildFooter(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final responsive = context.responsive;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.padding(24)),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _navigateToEditProfile(context),
              icon: Icon(Icons.edit, size: responsive.iconSize(18)),
              label: Text(
                'Edit Profil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.fontSize(14),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: responsive.padding(14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
                ),
                elevation: responsive.elevation(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final responsive = context.responsive;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.padding(24)),
      child: Column(
        children: [
          Text(
            'Version 0.1.0',
            style: TextStyle(
              fontSize: responsive.fontSize(12),
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: responsive.spacing(4)),
          Text(
            'Copyright © 2025 Pentagram',
            style: TextStyle(
              fontSize: responsive.fontSize(12),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
