import 'package:bloom/core/theme/data/settings_dao.dart';
import 'package:bloom/core/theme/theme_state.dart';

abstract interface class ThemeRepository {
  Future<ThemeState> load();
  Future<void> save(ThemeState state);
}

class DriftThemeRepository implements ThemeRepository {
  DriftThemeRepository(this._dao);

  final SettingsDao _dao;

  @override
  Future<ThemeState> load() async {
    final row = await _dao.getSettings();
    if (row == null) return const ThemeState();

    final mode = AppThemeMode.values.firstWhere(
      (m) => m.name == row.themeMode,
      orElse: () => const ThemeState().mode,
    );
    return ThemeState(mode: mode);
  }

  @override
  Future<void> save(ThemeState state) {
    return _dao.upsertThemeMode(state.mode.name);
  }
}
