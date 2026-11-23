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

  Future<void> saveOnboardingProgress({
    required String partialData,
    required int currentStep,
  }) async {
    final settings = await getSettings();

    if (settings == null) {
      await into(appSettingsTable).insert(
        AppSettingsTableCompanion.insert(
          id: Value(_defaultRowId),
          partialData: Value(partialData),
          currentStep: Value(currentStep),
        ),
      );
      return;
    }

    await (update(
      appSettingsTable,
    )..where((tbl) => tbl.id.equals(_defaultRowId))).write(
      AppSettingsTableCompanion(
        partialData: Value(partialData),
        currentStep: Value(currentStep),
      ),
    );
  }

  Future<void> markOnboardingCompleted() async {
    final settings = await getSettings();

    if (settings == null) {
      await into(appSettingsTable).insert(
        AppSettingsTableCompanion.insert(
          id: Value(_defaultRowId),
          onboardingCompleted: const Value(true),
        ),
      );
      return;
    }

    await (update(
      appSettingsTable,
    )..where((tbl) => tbl.id.equals(_defaultRowId))).write(
      const AppSettingsTableCompanion(
        onboardingCompleted: Value(true),
        partialData: Value(null),
        currentStep: Value(0),
      ),
    );
  }

  Future<void> clearOnboardingProgress() async {
    await (update(
      appSettingsTable,
    )..where((tbl) => tbl.id.equals(_defaultRowId))).write(
      const AppSettingsTableCompanion(
        partialData: Value(null),
        currentStep: Value(0),
        onboardingCompleted: Value(false),
      ),
    );
  }
}
