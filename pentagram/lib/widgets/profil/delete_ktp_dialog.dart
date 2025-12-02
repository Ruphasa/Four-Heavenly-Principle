import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class DeleteKtpDialog extends StatelessWidget {
  final VoidCallback onConfirmDelete;

  const DeleteKtpDialog({super.key, required this.onConfirmDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Hapus Foto KTP',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      content: const Text(
        'Apakah Anda yakin ingin menghapus foto KTP ini?',
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
            onConfirmDelete();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}
