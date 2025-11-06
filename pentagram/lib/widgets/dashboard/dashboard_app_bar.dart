import 'package:flutter/material.dart';
import 'package:pentagram/pages/notifikasi/notifikasi.dart';
import 'package:pentagram/pages/profil/profil_page.dart';
import 'package:pentagram/utils/app_colors.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilPage()),
              );
            },
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Selamat pagi, Bu RT!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Notifikasi()),
            );
          },
          icon: const Icon(Icons.notifications_outlined),
          color: Colors.white,
        ),
      ],
    );
  }
}
