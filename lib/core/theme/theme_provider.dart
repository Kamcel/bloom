import 'package:bloom/core/database/providers/database_provider.dart';
import 'package:bloom/core/theme/data/theme_repository.dart';
import 'package:bloom/core/theme/theme_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftThemeRepository(db.settingsDao);
});

class ThemeNotifier extends AsyncNotifier<ThemeState> {
  @override
  Future<ThemeState> build() => ref.watch(themeRepositoryProvider).load();

  Future<void> setMode(AppThemeMode mode) =>
      _update((s) => s.copyWith(mode: mode));

  Future<void> setTextScale(double value) =>
      _update((s) => s.copyWith(textScale: value.clamp(0.9, 1.4).toDouble()));

  Future<void> _update(ThemeState Function(ThemeState) change) async {
    final next = change(state.value ?? const ThemeState());
    state = AsyncData(next);
    await ref.read(themeRepositoryProvider).save(next);
  }
}

final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);
