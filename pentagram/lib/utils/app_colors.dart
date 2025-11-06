import 'package:flutter/material.dart';

/// Theme colors untuk aplikasi Jawara Pintar
/// Berdasarkan gradien biru-ungu dengan background putih
class AppColors {
  // Primary Colors - Gradien Biru ke Ungu
  static const Color primary = Color(0xFF5B6FDB); // Biru sedang
  static const Color primaryDark = Color(0xFF3D4FB8); // Biru tua
  static const Color primaryLight = Color(0xFF7B8FEB); // Biru muda
  
  static const Color secondary = Color(0xFF9B6FDB); // Ungu sedang
  static const Color secondaryDark = Color(0xFF7D4FB8); // Ungu tua
  static const Color secondaryLight = Color(0xFFBB8FEB); // Ungu muda
  
  // Gradient Colors
  static const Color gradientStart = Color(0xFF3D4FB8); // Biru tua kiri
  static const Color gradientMiddle = Color(0xFF5B6FDB); // Biru-ungu tengah
  static const Color gradientEnd = Color(0xFF9B6FDB); // Ungu kanan
  
  // Background Colors
  static const Color background = Color(0xFFFFFFFF); // Putih bersih
  static const Color backgroundGrey = Color(0xFFF5F6FA); // Abu-abu sangat terang
  static const Color cardBackground = Color(0xFFFFFFFF); // Putih untuk card
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A); // Hitam untuk teks utama
  static const Color textSecondary = Color(0xFF6B7280); // Abu-abu untuk teks sekunder
  static const Color textMuted = Color(0xFF9CA3AF); // Abu-abu muda untuk teks muted
  static const Color textOnPrimary = Color(0xFFFFFFFF); // Putih untuk teks di atas warna primary
  
  // Accent Colors
  static const Color accent = Color(0xFF5B6FDB); // Accent menggunakan primary
  
  // Status Colors
  static const Color success = Color(0xFF10B981); // Hijau untuk success
  static const Color error = Color(0xFFEF4444); // Merah untuk error
  static const Color warning = Color(0xFFF59E0B); // Kuning untuk warning
  static const Color info = Color(0xFF3B82F6); // Biru untuk info
  
  // UI Element Colors
  static const Color border = Color(0xFFE5E7EB); // Border abu-abu terang
  static const Color divider = Color(0xFFE5E7EB); // Divider abu-abu terang
  static const Color shadow = Color(0x1A000000); // Shadow hitam transparan
  
  // Button Colors
  static const Color buttonPrimary = primary; // Biru primary untuk button
  static const Color buttonSecondary = secondary; // Ungu secondary untuk button
  static const Color buttonDisabled = Color(0xFFD1D5DB); // Abu-abu untuk disabled
  
  // Icon Colors
  static const Color iconPrimary = Color(0xFF6B7280);
  static const Color iconSecondary = Color(0xFF9CA3AF);
  static const Color iconOnPrimary = Color(0xFFFFFFFF);
  
  // Gradient untuk UI
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gradientStart, gradientMiddle, gradientEnd],
  );
}
