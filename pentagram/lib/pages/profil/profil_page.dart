import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/providers/app_providers.dart';
import 'package:pentagram/pages/login/login_page.dart';
import 'package:pentagram/pages/profil/edit_profil_page.dart';
import 'package:pentagram/widgets/profil/profile_header.dart';
import 'package:pentagram/widgets/profil/profile_menu_section.dart';
import 'package:pentagram/widgets/profil/profile_menu_item.dart';

class ProfilPage extends ConsumerWidget {
  const ProfilPage({super.key});

  void _handleLogout(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Anda telah logout.'),
        duration: Duration(seconds: 2),
      ),
    );

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: ProfileHeader(
                name: 'Nyi Roro Lor',
                role: 'Administrator',
                imagePath: 'assets/images/profile.png',
                isVerified: true,
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
            _buildFooter(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _navigateToEditProfile(context),
              icon: const Icon(Icons.edit, size: 18),
              label: const Text(
                'Edit Profil',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            'Version 0.1.0',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          SizedBox(height: 4),
          Text(
            'Copyright © 2025 Pentagram',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
