import 'package:bloom/core/database/providers/database_provider.dart';
import 'package:bloom/features/onboarding/data/repository/onboarding_repository.dart';
import 'package:bloom/features/onboarding/data/storage/onboarding_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_provider.g.dart';

@riverpod
OnboardingStorage onboardingStorage(Ref ref) {
  final database = ref.watch(appDatabaseProvider);

  return OnboardingStorage(database.settingsDao);
}

@riverpod
OnboardingRepository onboardingRepository(Ref ref) {
  final storage = ref.watch(onboardingStorageProvider);

  return OnboardingRepository(storage);
}
