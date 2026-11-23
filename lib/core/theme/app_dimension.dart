import 'package:flutter/widgets.dart';

/// Spacing tokens (design system 2.6).
abstract final class AppSpacing {
  static const double tight = 8;
  static const double min = 12; // space-min
  static const double standard = 16; // space-standard
  static const double group = 24; // space-group
  static const double section = 32; // space-section
  static const double breathing = 48; // space-breathing
}

/// Corner radius tokens (design system 2.7). Circular = use CircleBorder/BoxShape.circle.
abstract final class AppRadius {
  static const double small = 12; // small buttons, inputs
  static const double card = 16; // standard cards
  static const double feature = 20; // feature and hero cards
  static const double sheet = 24; // bottom sheets

  static const BorderRadius smallAll = BorderRadius.all(Radius.circular(small));
  static const BorderRadius cardAll = BorderRadius.all(Radius.circular(card));
  static const BorderRadius featureAll = BorderRadius.all(
    Radius.circular(feature),
  );
  static const BorderRadius sheetTop = BorderRadius.vertical(
    top: Radius.circular(sheet),
  );
}

/// Component sizes (design system 2.9 and 2.10).
abstract final class AppSize {
  static const double buttonSmall = 40;
  static const double buttonMedium = 48;
  static const double buttonLarge = 56;
  static const double inputMinHeight = 52;
  static const double minTapTarget = 48;
  static const double iconSmall = 20;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double progressBar = 6;
}

abstract final class AppInsets {
  /// CHECK AGAINST FIGMA: horizontal screen margin on compact screens.
  static const double screenHorizontal = 20;
  static const EdgeInsets card = EdgeInsets.all(AppSpacing.standard);
  static const EdgeInsets feature = EdgeInsets.all(AppSpacing.group);
}
