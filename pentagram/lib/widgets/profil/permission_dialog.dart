import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pentagram/utils/responsive_helper.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({super.key});

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
        'Izin Kamera',
        style: TextStyle(
          fontSize: responsive.fontSize(16),
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      content: Text(
        'Aplikasi memerlukan akses kamera untuk memindai KTP. '
        'Silakan aktifkan izin kamera di pengaturan aplikasi.',
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
            openAppSettings();
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.padding(16),
              vertical: responsive.padding(10),
            ),
          ),
          child: Text(
            'Pengaturan',
            style: TextStyle(fontSize: responsive.fontSize(14)),
          ),
        ),
      ],
    );
  }
}
