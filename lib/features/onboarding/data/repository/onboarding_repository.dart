import 'package:bloom/features/onboarding/data/models/onboarding_data.dart';
import 'package:bloom/features/onboarding/data/storage/onboarding_storage.dart';

class OnboardingRepository {
  const OnboardingRepository(this._storage);

  final OnboardingStorage _storage;

  Future<void> saveProgress({
    required OnboardingData data,
    required int currentStep,
  }) {
    return _storage.saveProgress(data: data, currentStep: currentStep);
  }

  Future<({OnboardingData data, int currentStep})?> loadProgress() {
    return _storage.loadProgress();
  }

  Future<void> completeOnboarding() {
    return _storage.completeOnboarding();
  }

  Future<void> clearProgress() {
    return _storage.clearProgress();
  }
}
