import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/tables/app_settings_table.dart';
import 'package:drift/drift.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [AppSettingsTable])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  static const int _defaultRowId = 1;

  Future<AppSettingsTableData?> getSettings() {
    return (select(
      appSettingsTable,
    )..where((tbl) => tbl.id.equals(_defaultRowId))).getSingleOrNull();
  }

  Future<void> upsertThemeMode(String themeMode) {
    return into(appSettingsTable).insertOnConflictUpdate(
      AppSettingsTableCompanion.insert(
        id: const Value(_defaultRowId),
        themeMode: Value(themeMode),
      ),
    );
  }
}
