import 'package:flutter/material.dart';

/// font-heading and font-body (design system 2.4). Bundle both in pubspec.yaml.
abstract final class AppFont {
  static const String heading = 'Manrope';
  static const String body = 'Poppins';
}

abstract final class AppTypography {
  static TextTheme textTheme({
    required Color primary,
    required Color secondary,
  }) {
    TextStyle h(double size, double line, FontWeight w) => TextStyle(
      fontFamily: AppFont.heading,
      fontSize: size,
      height: line / size,
      fontWeight: w,
      color: primary,
    );
    TextStyle b(double size, double line, FontWeight w, [Color? color]) =>
        TextStyle(
          fontFamily: AppFont.body,
          fontSize: size,
          height: line / size,
          fontWeight: w,
          color: color ?? primary,
        );

    return TextTheme(
      displayLarge: h(42, 52, FontWeight.w800),
      displayMedium: h(32, 40, FontWeight.w800),
      displaySmall: h(28, 36, FontWeight.w800),
      headlineLarge: h(28, 36, FontWeight.w800),
      headlineMedium: h(24, 32, FontWeight.w800),
      headlineSmall: h(20, 28, FontWeight.w800),
      titleLarge: h(18, 26, FontWeight.w700),
      titleMedium: h(16, 24, FontWeight.w600),
      titleSmall: b(14, 20, FontWeight.w600),
      bodyLarge: b(16, 24, FontWeight.w400),
      bodyMedium: b(14, 22, FontWeight.w400),
      bodySmall: b(12, 18, FontWeight.w400, secondary),
      labelLarge: b(15, 20, FontWeight.w600),
      labelMedium: b(13, 18, FontWeight.w500),
      labelSmall: b(11, 16, FontWeight.w500, secondary),
    );
  }
}
