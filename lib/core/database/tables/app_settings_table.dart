import 'package:drift/drift.dart';

class AppSettingsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();

  IntColumn get currentStep => integer().withDefault(const Constant(0))();
  TextColumn get partialData =>
      text().nullable()(); //JSON for all answered questions

  @override
  Set<Column> get primaryKey => {id};
}
