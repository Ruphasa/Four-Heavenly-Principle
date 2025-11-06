import 'package:flutter/material.dart';

class DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final Widget content;
  final double width;

  DashboardItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
    this.width = 350,
  });
}