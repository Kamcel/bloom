import 'package:bloom/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'app_dimension.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(AppColorScheme.light, AppColors.light);
  static ThemeData get dark => _build(AppColorScheme.dark, AppColors.dark);

  static ThemeData _build(ColorScheme s, AppColors c) {
    final text = AppTypography.textTheme(
      primary: s.onSurface,
      secondary: s.onSurfaceVariant,
    );

    final cardShape = RoundedRectangleBorder(borderRadius: AppRadius.cardAll);
    final smallShape = RoundedRectangleBorder(borderRadius: AppRadius.smallAll);
    final disabledFill = s.onSurface.withValues(alpha: 0.12);
    final disabledText = s.onSurface.withValues(alpha: 0.38);

    const noBorder = OutlineInputBorder(
      borderRadius: AppRadius.smallAll,
      borderSide: BorderSide.none,
    );
    OutlineInputBorder line(Color color) => OutlineInputBorder(
      borderRadius: AppRadius.smallAll,
      borderSide: BorderSide(color: color, width: 1.5),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: s,
      scaffoldBackgroundColor: s.surface,
      canvasColor: s.surface,
      textTheme: text,
      fontFamily: AppFont.body,
      extensions: <ThemeExtension<dynamic>>[c],
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      dividerTheme: DividerThemeData(
        color: s.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: s.surface,
        foregroundColor: s.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),

      // Primary actions: pink fill. AppButton uses ElevatedButton, so both are set.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppSize.buttonLarge),
          shape: cardShape,
          textStyle: text.labelLarge,
          backgroundColor: s.primary,
          foregroundColor: s.onPrimary,
          disabledBackgroundColor: disabledFill,
          disabledForegroundColor: disabledText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          minimumSize: const Size(0, AppSize.buttonLarge),
          shape: cardShape,
          textStyle: text.labelLarge,
          backgroundColor: s.primary,
          foregroundColor: s.onPrimary,
          disabledBackgroundColor: disabledFill,
          disabledForegroundColor: disabledText,
        ),
      ),
      // Secondary actions: Deep Lavender.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppSize.buttonMedium),
          shape: cardShape,
          textStyle: text.labelLarge,
          foregroundColor: s.secondary,
          disabledForegroundColor: disabledText,
          side: BorderSide(color: s.secondary, width: 1.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, AppSize.buttonMedium),
          shape: smallShape,
          textStyle: text.labelLarge,
          foregroundColor: s.secondary,
          disabledForegroundColor: disabledText,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: s.primary,
        foregroundColor: s.onPrimary,
        elevation: 2,
        shape: cardShape,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.surfaceContainer,
        constraints: const BoxConstraints(minHeight: AppSize.inputMinHeight),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.standard,
          vertical: AppSpacing.standard,
        ),
        floatingLabelBehavior:
            FloatingLabelBehavior.never, // labels sit above fields
        hintStyle: text.bodyMedium?.copyWith(color: s.onSurfaceVariant),
        errorStyle: text.bodySmall?.copyWith(color: s.error),
        prefixIconColor: s.onSurfaceVariant,
        suffixIconColor: s.onSurfaceVariant,
        border: noBorder,
        enabledBorder: noBorder,
        disabledBorder: noBorder,
        focusedBorder: line(s.primary),
        errorBorder: line(s.error),
        focusedErrorBorder: line(s.error),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: s.primary,
        selectionColor: s.primary.withValues(alpha: 0.35),
        selectionHandleColor: s.primary,
      ),

      cardTheme: CardThemeData(
        color: s.surfaceContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: cardShape,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: s.surface,
        selectedColor: s.secondaryContainer,
        checkmarkColor: s.onSecondaryContainer,
        side: BorderSide(color: s.outlineVariant),
        shape: const StadiumBorder(),
        labelStyle: text.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.tight),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: s.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: s.outlineVariant,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: s.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.featureAll),
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyMedium,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: s.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: s.primaryContainer,
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return text.labelSmall?.copyWith(
            color: selected ? s.onSurface : s.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: AppSize.iconMedium,
            color: selected ? s.onPrimaryContainer : s.onSurfaceVariant,
          );
        }),
      ),

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        checkColor: WidgetStatePropertyAll(s.onPrimary),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return disabledFill;
          return states.contains(WidgetState.selected)
              ? s.primary
              : Colors.transparent;
        }),
        side: WidgetStateBorderSide.resolveWith(
          (states) => BorderSide(color: s.primary, width: 2),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.disabled) ? disabledText : s.primary,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? s.primary
              : s.surfaceContainerHighest,
        ),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? s.onPrimary : s.outline,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.transparent
              : s.outline,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: s.primary,
        inactiveTrackColor: s.primaryContainer,
        thumbColor: s.primary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: s.primary,
        linearTrackColor: s.primaryContainer,
        circularTrackColor: s.primaryContainer,
        linearMinHeight: AppSize.progressBar,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: s.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(color: s.onInverseSurface),
        actionTextColor: s.inversePrimary,
        shape: smallShape,
      ),
    );
  }
}
