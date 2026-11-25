import 'dart:async';

import 'package:bloom/core/models/dating_method.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_data.dart';
import 'package:bloom/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

typedef OnboardingState = ({
  OnboardingData data,
  int currentStep,
  bool isSaving,
  bool isSubmitting,
});

@riverpod
class OnboardingController extends _$OnboardingController {
  static const int totalSteps = 3;
  Timer? _debounceTimer;
  Future<void>? _saveOperation;

  @override
  Future<OnboardingState> build() async {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });

    final repository = ref.watch(onboardingRepositoryProvider);
    final progress = await repository.loadProgress();

    if (progress != null) {
      return (
        data: progress.data,
        currentStep: progress.currentStep,
        isSaving: false,
        isSubmitting: false,
      );
    }

    return (
      data: const OnboardingData(),
      currentStep: 0,
      isSaving: false,
      isSubmitting: false,
    );
  }

  //Personal information

  String? validatePersonalInformation(OnboardingData data) {
    if (data.name == null || data.name!.trim().isEmpty) {
      return 'Please enter your name.';
    }

    if (data.dateOfBirth == null) {
      return 'Please select your date of birth.';
    }

    if (data.dateOfBirth!.isAfter(DateTime.now())) {
      return 'Date of birth cannot be in the future.';
    }

    if (data.country == null || data.country!.trim().isEmpty) {
      return 'Please select your country.';
    }

    if (data.state == null || data.state!.trim().isEmpty) {
      return 'Please select your state.';
    }

    if (data.city == null || data.city!.trim().isEmpty) {
      return 'Please select your city.';
    }

    return null;
  }

  void updateName(String? name) {
    final current = state.asData?.value;
    if (current == null) return;

    updateData(current.data.copyWith(name: name));
  }

  void updateDOB(DateTime? dob) {
    final current = state.asData?.value;
    if (current == null) return;

    updateData(current.data.copyWith(dateOfBirth: dob));
  }

  void updateCountry(String? country) {
    final current = state.asData?.value;
    if (current == null) return;

    updateData(
      current.data.copyWith(country: country, state: null, city: null),
    );
  }

  void updateState(String? stateProvince) {
    final current = state.asData?.value;
    if (current == null) return;

    updateData(current.data.copyWith(state: stateProvince, city: null));
  }

  void updateCity(String? city) {
    final current = state.asData?.value;
    if (current == null) return;

    updateData(current.data.copyWith(city: city));
  }

  // Pregnancy journey
  //last Menstral period
  void updateLastMenstrualPeriod(DatingMethod datingMethod) {
    final current = state.asData?.value;
    if (current == null) return;

    updateData(current.data.copyWith(datingMethod: datingMethod));
  }

  //conception date
  void updateConceptionDate(DatingMethod datingMethod) {
    final current = state.asData?.value;
    if (current == null) return;

    updateData(current.data.copyWith(datingMethod: datingMethod));
  }

  //ivf transfer
  void updateIVFTransferDate(DatingMethod datingMethod) {
    final current = state.asData?.value;
    if (current == null) return;

    updateData(current.data.copyWith(datingMethod: datingMethod));
  }

  //ultasound
  void updateUltrasoundDate(DatingMethod datingMethod) {
    final current = state.asData?.value;
    if (current == null) return;

    updateData(current.data.copyWith(datingMethod: datingMethod));
  }

  //I know my due date
  void updateKnownnDate(DatingMethod datingMethod) {
    final current = state.asData?.value;
    if (current == null) return;

    updateData(current.data.copyWith(datingMethod: datingMethod));
  }

  // i dont know
  void updateUnknowDate(DatingMethod datingMethod) {
    final current = state.asData?.value;
    if (current == null) return;

    updateData(current.data.copyWith(datingMethod: datingMethod));
  }

  //confirmed by professional
  void updateProfessionalDate(DatingMethod datingMethod) {
    final current = state.asData?.value;
    if (current == null) return;

    updateData(current.data.copyWith(datingMethod: datingMethod));
  }

  //first pregnancy?

  void updateData(OnboardingData data) {
    final current = state.asData?.value;
    if (current == null) return;

    state = AsyncData((
      data: data,
      currentStep: current.currentStep,
      isSaving: current.isSaving,
      isSubmitting: current.isSubmitting,
    ));

    _scheduleAutosave();
  }

  void _scheduleAutosave() {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      saveProgress();
    });
  }

  Future<void> saveProgress() {
    final previousSave = _saveOperation ?? Future<void>.value();

    final newSave = previousSave
        .catchError((Object error) {
          // Allow the next save to proceed even if the previous one failed.
        })
        .then((_) async {
          final current = state.asData?.value;
          if (current == null) return;

          state = AsyncData((
            data: current.data,
            currentStep: current.currentStep,
            isSaving: true,
            isSubmitting: current.isSubmitting,
          ));

          try {
            final repository = ref.read(onboardingRepositoryProvider);

            await repository.saveProgress(
              data: current.data,
              currentStep: current.currentStep,
            );
          } finally {
            final latest = state.asData?.value;

            if (latest != null) {
              state = AsyncData((
                data: latest.data,
                currentStep: latest.currentStep,
                isSaving: false,
                isSubmitting: latest.isSubmitting,
              ));
            }
          }
        });

    _saveOperation = newSave;

    return newSave;
  }

  Future<void> nextStep() async {
    final current = state.asData?.value;
    if (current == null) return;

    if (current.currentStep >= totalSteps - 1) return;

    if (current.currentStep == 0 &&
        validatePersonalInformation(current.data) != null) {
      return;
    }

    _debounceTimer?.cancel();

    state = AsyncData((
      data: current.data,
      currentStep: current.currentStep + 1,
      isSaving: current.isSaving,
      isSubmitting: current.isSubmitting,
    ));

    await saveProgress();
  }

  Future<void> previousStep() async {
    final current = state.asData?.value;
    if (current == null || current.currentStep == 0) return;

    _debounceTimer?.cancel();

    state = AsyncData((
      data: current.data,
      currentStep: current.currentStep - 1,
      isSaving: current.isSaving,
      isSubmitting: current.isSubmitting,
    ));

    await saveProgress();
  }

  Future<void> completeOnboarding() async {
    final current = state.asData?.value;
    if (current == null || current.isSubmitting) return;

    _debounceTimer?.cancel();

    state = AsyncData((
      data: current.data,
      currentStep: current.currentStep,
      isSaving: current.isSaving,
      isSubmitting: true,
    ));

    try {
      await saveProgress();

      final repository = ref.read(onboardingRepositoryProvider);
      await repository.completeOnboarding();
    } finally {
      final latest = state.asData?.value;

      if (latest != null) {
        state = AsyncData((
          data: latest.data,
          currentStep: latest.currentStep,
          isSaving: latest.isSaving,
          isSubmitting: false,
        ));
      }
    }
  }

  Future<void> clearProgress() async {
    _debounceTimer?.cancel();

    // Wait for any ongoing or queued save to finish.
    try {
      await _saveOperation;
    } catch (_) {
      // Continue clearing even if the previous save failed.
    }

    final repository = ref.read(onboardingRepositoryProvider);

    await repository.clearProgress();

    state = AsyncData((
      data: const OnboardingData(),
      currentStep: 0,
      isSaving: false,
      isSubmitting: false,
    ));
  }
}
