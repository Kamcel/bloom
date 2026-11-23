import 'package:bloom/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'app_dimension.dart';
import 'app_responsiveness.dart';

extension AppContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get text => theme.textTheme;
  AppColors get colors => theme.extension<AppColors>()!;
  Responsive get responsive => Responsive.of(this);
  bool get isDark => theme.brightness == Brightness.dark;

  /// True when the system asks for fewer animations. Respect it in every animation.
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);
}

/// Spacing widgets: `Gap.vStandard`, `Gap.hMin`, and so on.
abstract final class Gap {
  static const vMin = SizedBox(height: AppSpacing.min);
  static const vStandard = SizedBox(height: AppSpacing.standard);
  static const vGroup = SizedBox(height: AppSpacing.group);
  static const vSection = SizedBox(height: AppSpacing.section);
  static const vBreathing = SizedBox(height: AppSpacing.breathing);
  static const hMin = SizedBox(width: AppSpacing.min);
  static const hStandard = SizedBox(width: AppSpacing.standard);
  static const hGroup = SizedBox(width: AppSpacing.group);
}
