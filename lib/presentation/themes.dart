import 'package:flutter/material.dart';

abstract interface class AppColors {
  static const Color bgSurface = Color(0xFFFAFBFA);
  static const Color iconsTint = Colors.black12;
  static const Color descriptionText = Colors.black38;
  static const Color buttonColor = Colors.blue;
}

abstract interface class AppSpacing {
  static const double small = 4;
  static const double medium = 8;
  static const double large = 16;
}

abstract interface class AppFonts {
  static const String sansSerif = 'sans-serif';
  static const String serif = 'serif';
}

abstract interface class AppFontSizes {
  static const double small = 12;
  static const double medium = 14;
  static const double large = 16;
  static const double extraLarge = 24;
}