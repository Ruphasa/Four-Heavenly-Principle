import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Izin Kamera Diperlukan',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      content: const Text(
        'Aplikasi memerlukan akses kamera untuk memindai KTP. '
        'Silakan aktifkan izin kamera di pengaturan aplikasi.',
        style: TextStyle(fontSize: 14, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            openAppSettings();
          },
          child: const Text('Buka Pengaturan'),
        ),
      ],
    );
  }
}
