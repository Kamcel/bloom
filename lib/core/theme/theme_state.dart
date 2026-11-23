import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_state.freezed.dart';

enum AppThemeMode { system, light, dark }

@freezed
abstract class ThemeState with _$ThemeState {
  const ThemeState._();

  const factory ThemeState({
    /// Default is light until a dark theme is approved in the design system.
    @Default(AppThemeMode.system) AppThemeMode mode,

    /// User text-size multiplier, applied on top of the system setting.
    @Default(1.0) double textScale,
  }) = _ThemeState;

  ThemeMode get themeMode => switch (mode) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}
