import 'package:flutter/material.dart';

/// Helper class for broadcast-related utility functions
class BroadcastHelper {
  BroadcastHelper._();

  /// Get color for broadcast category
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Kegiatan':
        return const Color(0xFF42A5F5);
      case 'Informasi Umum':
        return const Color(0xFF66BB6A);
      case 'Iuran':
        return const Color(0xFFFFB74D);
      case 'Keamanan':
        return const Color(0xFFEF5350);
      case 'Kesehatan':
        return const Color(0xFFAB47BC);
      default:
        return Colors.grey;
    }
  }

  /// Get icon for broadcast category
  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Kegiatan':
        return Icons.event;
      case 'Informasi Umum':
        return Icons.info;
      case 'Iuran':
        return Icons.payment;
      case 'Keamanan':
        return Icons.security;
      case 'Kesehatan':
        return Icons.medical_services;
      default:
        return Icons.message;
    }
  }

  /// Format date for broadcast message display
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
