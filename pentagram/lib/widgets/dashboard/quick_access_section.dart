import 'package:flutter/material.dart';
import 'package:pentagram/pages/broadcast/broadcast_page.dart';
import 'package:pentagram/pages/channel_transfer/daftar_channel.dart';
import 'package:pentagram/pages/dashboard/components/quick_access_card.dart';
import 'package:pentagram/pages/manajemen_pengguna/daftar_pengguna.dart';
import 'package:pentagram/pages/penerimaan_warga/penerimaan_warga_page.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Akses cepat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  QuickAccessCard(
                    color: const Color(0xFF80CBC4),
                    icon: Icons.campaign,
                    label: 'Broadcast',
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => const BroadcastPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  QuickAccessCard(
                    color: const Color(0xFF9575CD),
                    icon: Icons.tv_rounded,
                    label: 'Daftar Channel',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DaftarChannelPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  QuickAccessCard(
                    color: const Color(0xFFFFB74D),
                    icon: Icons.group_rounded,
                    label: 'Daftar Pengguna',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DaftarPenggunaPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  QuickAccessCard(
                    color: const Color(0xFF4DB6AC),
                    icon: Icons.home_rounded,
                    label: 'Penerimaan Warga',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PenerimaanWargaPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
