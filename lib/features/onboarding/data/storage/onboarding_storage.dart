import 'dart:convert';

import 'package:bloom/core/theme/data/settings_dao.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_data.dart';

class OnboardingStorage {
  const OnboardingStorage(this._settingsDao);

  final SettingsDao _settingsDao;

  /// Saves answers and the current onboarding step.
  Future<void> saveProgress({
    required OnboardingData data,
    required int currentStep,
  }) async {
    final json = jsonEncode(data.toJson());

    await _settingsDao.saveOnboardingProgress(
      partialData: json,
      currentStep: currentStep,
    );
  }

  /// Restores previously saved answers and step.
  Future<({OnboardingData data, int currentStep})?> loadProgress() async {
    final settings = await _settingsDao.getSettings();

    if (settings == null || settings.partialData == null) {
      return null;
    }

    final decoded = jsonDecode(settings.partialData!);
    final json = Map<String, dynamic>.from(decoded as Map);

    return (
      data: OnboardingData.fromJson(json),
      currentStep: settings.currentStep,
    );
  }

  /// Marks onboarding as completed.
  Future<void> completeOnboarding() {
    return _settingsDao.markOnboardingCompleted();
  }

  /// Clears saved onboarding answers.
  Future<void> clearProgress() {
    return _settingsDao.clearOnboardingProgress();
  }
}
