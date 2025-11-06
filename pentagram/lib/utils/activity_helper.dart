import 'package:flutter/material.dart';
import 'package:pentagram/repositories/activity_constants.dart';

class ActivityHelper {
  ActivityHelper._();

  // Get color for category
  static Color getCategoryColor(String category) {
    final colorValue = ActivityConstants.categoryColors[category];
    return colorValue != null ? Color(colorValue) : const Color(0xFF2196F3);
  }

  // Format date
  static String formatDate(DateTime date, {bool short = false}) {
    final months = short
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des']
        : ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Format date with time
  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if date is in the future
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  // Get relative date string
  static String getRelativeDateString(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (isToday(date)) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Besok';
    } else if (difference.inDays == -1) {
      return 'Kemarin';
    } else if (difference.inDays > 1 && difference.inDays <= 7) {
      return '${difference.inDays} hari lagi';
    } else if (difference.inDays < -1 && difference.inDays >= -7) {
      return '${difference.inDays.abs()} hari yang lalu';
    } else {
      return formatDate(date, short: true);
    }
  }
}