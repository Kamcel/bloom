import 'package:flutter/material.dart';

/// Raw palette tokens (design system).
abstract final class AppColor {
  // Approved palette
  static const Color dustyPink = Color(
    0xFFD8A3B5,
  ); // Primary (dark theme, illustrations)
  static const Color mutedRose = Color(0xFFB77B9B); // Secondary accent
  static const Color softLavender = Color(0xFFC9B9DE); // Supporting
  static const Color deepLavender = Color(0xFF806B9B); // Secondary actions
  static const Color warmIvory = Color(0xFFF7F0E8); // Surface
  static const Color softWhite = Color(0xFFFFFCFA); // Main background
  static const Color deepPlum = Color(0xFF493C4B); // Primary text
  static const Color softSage = Color(0xFFA8BBA8); // Positive accents
  static const Color mutedTaupe = Color(
    0xFF91858C,
  ); // icons, borders, large text only

  // Proposed (not in the approved palette yet)
  /// Deeper pink for primary UI on LIGHT backgrounds. 4.6:1 with Soft White.
  static const Color primaryDeep = Color(0xFFA65D7B);
  static const Color deepTaupe = Color(
    0xFF6F646B,
  ); // small secondary text, 4.5:1+
  static const Color urgent = Color(0xFFB3475F);
  static const Color urgentSurface = Color(0xFFFBEEF1);
  static const Color hairline = Color(0xFFE8DFD6);

  // Derived tints Material 3 needs for container roles
  static const Color pinkTint = Color(0xFFF3DEE6);
  static const Color sageTint = Color(0xFFE2EBE2);
  static const Color ivoryLow = Color(0xFFFBF7F2);
  static const Color ivoryHigh = Color(0xFFF1E9DF);
  static const Color ivoryHighest = Color(0xFFEBE2D8);
  static const Color ivoryDim = Color(0xFFEFE7DE);
  static const Color onUrgentTint = Color(0xFF7A1F37);
}

/// Material 3 colour schemes.
/// Light: deep pink primary with a Soft White label.
/// Dark (provisional): Dusty Pink primary with a dark label.
abstract final class AppColorScheme {
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: AppColor.primaryDeep,
    onPrimary: AppColor.softWhite,
    primaryContainer: AppColor.pinkTint,
    onPrimaryContainer: AppColor.deepPlum,
    secondary: AppColor.deepLavender,
    onSecondary: AppColor.softWhite,
    secondaryContainer: AppColor.softLavender,
    onSecondaryContainer: AppColor.deepPlum,
    tertiary: AppColor.softSage,
    onTertiary: AppColor.deepPlum,
    tertiaryContainer: AppColor.sageTint,
    onTertiaryContainer: AppColor.deepPlum,
    error: AppColor.urgent,
    onError: Colors.white,
    errorContainer: AppColor.urgentSurface,
    onErrorContainer: AppColor.onUrgentTint,
    surface: AppColor.softWhite,
    onSurface: AppColor.deepPlum,
    onSurfaceVariant: AppColor.deepTaupe,
    surfaceDim: AppColor.ivoryDim,
    surfaceBright: AppColor.softWhite,
    surfaceContainerLowest: AppColor.softWhite,
    surfaceContainerLow: AppColor.ivoryLow,
    surfaceContainer: AppColor.warmIvory,
    surfaceContainerHigh: AppColor.ivoryHigh,
    surfaceContainerHighest: AppColor.ivoryHighest,
    outline: AppColor.mutedTaupe,
    outlineVariant: AppColor.hairline,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColor.deepPlum,
    onInverseSurface: AppColor.softWhite,
    inversePrimary: AppColor.dustyPink,
  );

  /// PROVISIONAL: dark mode isn't in the approved design system yet.
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColor.dustyPink,
    onPrimary: Color(0xFF3A2A35),
    primaryContainer: Color(0xFF5A3D4C),
    onPrimaryContainer: Color(0xFFF5DCE5),
    secondary: Color(0xFFB39CD1),
    onSecondary: Color(0xFF2F2540),
    secondaryContainer: Color(0xFF4A3F59),
    onSecondaryContainer: Color(0xFFE5DAF2),
    tertiary: Color(0xFFB5C9B5),
    onTertiary: Color(0xFF24362A),
    tertiaryContainer: Color(0xFF3C4F3F),
    onTertiaryContainer: Color(0xFFD6E8D6),
    error: Color(0xFFE27A91),
    onError: Color(0xFF3B0A18),
    errorContainer: Color(0xFF5C1D2E),
    onErrorContainer: Color(0xFFFFD9E0),
    surface: Color(0xFF1E1920),
    onSurface: Color(0xFFF3ECF4),
    onSurfaceVariant: Color(0xFFB9ADBD),
    surfaceDim: Color(0xFF181319),
    surfaceBright: Color(0xFF3A323D),
    surfaceContainerLowest: Color(0xFF150F17),
    surfaceContainerLow: Color(0xFF231D25),
    surfaceContainer: Color(0xFF2A232D),
    surfaceContainerHigh: Color(0xFF342C37),
    surfaceContainerHighest: Color(0xFF3F3642),
    outline: Color(0xFF8E8294),
    outlineVariant: Color(0xFF3A3240),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFF3ECF4),
    onInverseSurface: Color(0xFF1E1920),
    inversePrimary: AppColor.primaryDeep,
  );
}

/// Semantic roles for your own widgets: context.colors.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.card,
    required this.inputBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.onPrimary,
    required this.primary,
    required this.primarySoft,
    required this.accent,
    required this.highlight,
    required this.success,
    required this.urgent,
    required this.urgentSurface,
    required this.divider,
    required this.icon,
  });

  final Color background, card, inputBackground;
  final Color textPrimary, textSecondary, onPrimary;
  final Color primary, primarySoft, accent, highlight, success;
  final Color urgent, urgentSurface, divider, icon;

  /// Alias: the secondary role (Deep Lavender) is called accent here.
  Color get secondary => accent;

  static const AppColors light = AppColors(
    background: AppColor.softWhite,
    card: AppColor.warmIvory,
    inputBackground: AppColor.warmIvory,
    textPrimary: AppColor.deepPlum,
    textSecondary: AppColor.deepTaupe,
    onPrimary: AppColor.softWhite,
    primary: AppColor.primaryDeep,
    primarySoft: AppColor.softLavender,
    accent: AppColor.deepLavender,
    highlight: AppColor.mutedRose,
    success: AppColor.softSage,
    urgent: AppColor.urgent,
    urgentSurface: AppColor.urgentSurface,
    divider: AppColor.hairline,
    icon: AppColor.mutedTaupe,
  );

  static const AppColors dark = AppColors(
    background: Color(0xFF1E1920),
    card: Color(0xFF2A232D),
    inputBackground: Color(0xFF2A232D),
    textPrimary: Color(0xFFF3ECF4),
    textSecondary: Color(0xFFB9ADBD),
    onPrimary: Color(0xFF3A2A35),
    primary: AppColor.dustyPink,
    primarySoft: Color(0xFF4A3F59),
    accent: Color(0xFFB39CD1),
    highlight: AppColor.mutedRose,
    success: Color(0xFF8FA68F),
    urgent: Color(0xFFE27A91),
    urgentSurface: Color(0xFF3A2430),
    divider: Color(0xFF3A3240),
    icon: Color(0xFF8E8294),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? card,
    Color? inputBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? onPrimary,
    Color? primary,
    Color? primarySoft,
    Color? accent,
    Color? highlight,
    Color? success,
    Color? urgent,
    Color? urgentSurface,
    Color? divider,
    Color? icon,
  }) => AppColors(
    background: background ?? this.background,
    card: card ?? this.card,
    inputBackground: inputBackground ?? this.inputBackground,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    onPrimary: onPrimary ?? this.onPrimary,
    primary: primary ?? this.primary,
    primarySoft: primarySoft ?? this.primarySoft,
    accent: accent ?? this.accent,
    highlight: highlight ?? this.highlight,
    success: success ?? this.success,
    urgent: urgent ?? this.urgent,
    urgentSurface: urgentSurface ?? this.urgentSurface,
    divider: divider ?? this.divider,
    icon: icon ?? this.icon,
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      background: l(background, other.background),
      card: l(card, other.card),
      inputBackground: l(inputBackground, other.inputBackground),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      onPrimary: l(onPrimary, other.onPrimary),
      primary: l(primary, other.primary),
      primarySoft: l(primarySoft, other.primarySoft),
      accent: l(accent, other.accent),
      highlight: l(highlight, other.highlight),
      success: l(success, other.success),
      urgent: l(urgent, other.urgent),
      urgentSurface: l(urgentSurface, other.urgentSurface),
      divider: l(divider, other.divider),
      icon: l(icon, other.icon),
    );
  }
}
