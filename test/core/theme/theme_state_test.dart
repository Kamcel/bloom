import 'package:bloom/core/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defaults to system mode at normal text size', () {
    const state = ThemeState();

    expect(state.mode, AppThemeMode.system);
    expect(state.textScale, 1.0);
  });

  test('themeMode maps every AppThemeMode', () {
    expect(
      const ThemeState(mode: AppThemeMode.system).themeMode,
      ThemeMode.system,
    );
    expect(
      const ThemeState(mode: AppThemeMode.light).themeMode,
      ThemeMode.light,
    );
    expect(const ThemeState(mode: AppThemeMode.dark).themeMode, ThemeMode.dark);
  });

  test('copyWith changes only what is passed', () {
    const state = ThemeState(mode: AppThemeMode.dark, textScale: 1.2);

    final changed = state.copyWith(mode: AppThemeMode.light);

    expect(changed.mode, AppThemeMode.light);
    expect(changed.textScale, 1.2);
  });

  test('equal values are equal', () {
    expect(
      const ThemeState(mode: AppThemeMode.dark),
      const ThemeState(mode: AppThemeMode.dark),
    );
  });
}
