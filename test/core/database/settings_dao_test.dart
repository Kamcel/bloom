// These tests use a real SQLite database in memory (no files, no mocks).
// `flutter test` runs on your computer, so it needs the sqlite3 library
// available there. If NativeDatabase.memory() fails to open, see
// https://drift.simonbinder.eu/testing/ for the setup on your OS.
import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/theme/data/theme_repository.dart';
import 'package:bloom/core/theme/theme_state.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('SettingsDao', () {
    test('has no settings row on a fresh database', () async {
      expect(await db.settingsDao.getSettings(), isNull);
    });

    test('upsertThemeMode creates the row with sensible defaults', () async {
      await db.settingsDao.upsertThemeMode('dark');

      final row = (await db.settingsDao.getSettings())!;
      expect(row.themeMode, 'dark');
      expect(row.onboardingCompleted, isFalse);
      expect(row.currentStep, 0);
      expect(row.partialData, isNull);
    });

    test(
      'upsertThemeMode updates the same row instead of adding one',
      () async {
        await db.settingsDao.upsertThemeMode('dark');
        await db.settingsDao.upsertThemeMode('light');

        final rows = await db.select(db.appSettingsTable).get();
        expect(rows.length, 1);
        expect(rows.single.themeMode, 'light');
      },
    );

    test('upsertThemeMode does not wipe saved onboarding progress', () async {
      await db.settingsDao.saveOnboardingProgress(
        partialData: '{"name":"Amina"}',
        currentStep: 2,
      );

      await db.settingsDao.upsertThemeMode('dark');

      final row = (await db.settingsDao.getSettings())!;
      expect(row.partialData, '{"name":"Amina"}');
      expect(row.currentStep, 2);
      expect(row.themeMode, 'dark');
    });

    test('saveOnboardingProgress creates the row when there is none', () async {
      await db.settingsDao.saveOnboardingProgress(
        partialData: '{"a":1}',
        currentStep: 1,
      );

      final row = (await db.settingsDao.getSettings())!;
      expect(row.partialData, '{"a":1}');
      expect(row.currentStep, 1);
      expect(row.themeMode, 'system');
      expect(row.onboardingCompleted, isFalse);
    });

    test('saveOnboardingProgress overwrites and keeps the theme', () async {
      await db.settingsDao.upsertThemeMode('dark');
      await db.settingsDao.saveOnboardingProgress(
        partialData: '{"a":1}',
        currentStep: 1,
      );
      await db.settingsDao.saveOnboardingProgress(
        partialData: '{"a":2}',
        currentStep: 2,
      );

      final rows = await db.select(db.appSettingsTable).get();
      expect(rows.length, 1);
      expect(rows.single.partialData, '{"a":2}');
      expect(rows.single.currentStep, 2);
      expect(rows.single.themeMode, 'dark');
    });

    test('markOnboardingCompleted flags it and clears progress', () async {
      await db.settingsDao.upsertThemeMode('dark');
      await db.settingsDao.saveOnboardingProgress(
        partialData: '{"a":1}',
        currentStep: 2,
      );

      await db.settingsDao.markOnboardingCompleted();

      final row = (await db.settingsDao.getSettings())!;
      expect(row.onboardingCompleted, isTrue);
      expect(row.partialData, isNull);
      expect(row.currentStep, 0);
      expect(row.themeMode, 'dark');
    });

    test('markOnboardingCompleted works on a fresh database too', () async {
      await db.settingsDao.markOnboardingCompleted();

      final row = (await db.settingsDao.getSettings())!;
      expect(row.onboardingCompleted, isTrue);
    });

    test('clearOnboardingProgress resets progress and completion', () async {
      await db.settingsDao.saveOnboardingProgress(
        partialData: '{"a":1}',
        currentStep: 2,
      );
      await db.settingsDao.markOnboardingCompleted();

      await db.settingsDao.clearOnboardingProgress();

      final row = (await db.settingsDao.getSettings())!;
      expect(row.onboardingCompleted, isFalse);
      expect(row.partialData, isNull);
      expect(row.currentStep, 0);
    });

    test(
      'clearOnboardingProgress on a fresh database does not throw',
      () async {
        await expectLater(db.settingsDao.clearOnboardingProgress(), completes);
      },
    );
  });

  group('DriftThemeRepository', () {
    test('loads the default theme when nothing is saved', () async {
      final repo = DriftThemeRepository(db.settingsDao);

      expect(await repo.load(), const ThemeState());
    });

    test('a saved mode is loaded back, for every mode', () async {
      final repo = DriftThemeRepository(db.settingsDao);

      for (final mode in AppThemeMode.values) {
        await repo.save(ThemeState(mode: mode));

        expect((await repo.load()).mode, mode);
      }
    });

    test('an unrecognised stored value falls back to the default', () async {
      await db
          .into(db.appSettingsTable)
          .insert(
            AppSettingsTableCompanion.insert(
              id: const Value(1),
              themeMode: const Value('sepia'),
            ),
          );

      final state = await DriftThemeRepository(db.settingsDao).load();

      expect(state.mode, const ThemeState().mode);
    });
  });
}
