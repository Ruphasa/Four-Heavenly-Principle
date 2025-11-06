import 'package:flutter/material.dart';

/// Helper class untuk membuat UI responsive
class ResponsiveHelper {
  final BuildContext context;
  
  ResponsiveHelper(this.context);
  
  /// Get screen width
  double get screenWidth => MediaQuery.of(context).size.width;
  
  /// Get screen height
  double get screenHeight => MediaQuery.of(context).size.height;
  
  /// Check if device is compact (mobile small)
  bool get isCompact => screenWidth < 400;
  
  /// Check if device is mobile (< 600)
  bool get isMobile => screenWidth < 600;
  
  /// Check if device is tablet (600-900)
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  
  /// Check if device is desktop (>= 900)
  bool get isDesktop => screenWidth >= 900;
  
  /// Responsive font size
  double fontSize(double base) {
    if (isCompact) return base * 0.85;
    if (isMobile) return base * 0.9;
    if (isTablet) return base * 1.0;
    return base * 1.1;
  }
  
  /// Responsive icon size
  double iconSize(double base) {
    if (isCompact) return base * 0.85;
    if (isMobile) return base * 0.9;
    return base;
  }
  
  /// Responsive padding
  double padding(double base) {
    if (isCompact) return base * 0.75;
    if (isMobile) return base * 0.85;
    return base;
  }
  
  /// Responsive spacing
  double spacing(double base) {
    if (isCompact) return base * 0.75;
    if (isMobile) return base * 0.85;
    return base;
  }
  
  /// Responsive card elevation
  double elevation(double base) {
    if (isCompact) return base * 0.8;
    return base;
  }
  
  /// Responsive border radius
  double borderRadius(double base) {
    if (isCompact) return base * 0.85;
    return base;
  }
  
  /// Get responsive value based on screen size
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}

/// Extension untuk mudah mengakses responsive helper
extension ResponsiveContext on BuildContext {
  ResponsiveHelper get responsive => ResponsiveHelper(this);
}
