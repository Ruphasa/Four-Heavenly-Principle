import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';

class DeleteKtpDialog extends StatelessWidget {
  final VoidCallback onConfirmDelete;

  const DeleteKtpDialog({super.key, required this.onConfirmDelete});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
      ),
      titlePadding: EdgeInsets.fromLTRB(
        responsive.padding(20),
        responsive.padding(20),
        responsive.padding(20),
        responsive.padding(12),
      ),
      contentPadding: EdgeInsets.fromLTRB(
        responsive.padding(20),
        0,
        responsive.padding(20),
        responsive.padding(12),
      ),
      actionsPadding: EdgeInsets.fromLTRB(
        responsive.padding(20),
        0,
        responsive.padding(20),
        responsive.padding(16),
      ),
      title: Text(
        'Hapus KTP',
        style: TextStyle(
          fontSize: responsive.fontSize(16),
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      content: Text(
        'Apakah Anda yakin ingin menghapus foto KTP ini?',
        style: TextStyle(
          fontSize: responsive.fontSize(14),
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Batal',
            style: TextStyle(fontSize: responsive.fontSize(14)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmDelete();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            padding: EdgeInsets.symmetric(
              horizontal: responsive.padding(16),
              vertical: responsive.padding(10),
            ),
          ),
          child: Text(
            'Hapus',
            style: TextStyle(fontSize: responsive.fontSize(14)),
          ),
        ),
      ],
    );
  }
}
