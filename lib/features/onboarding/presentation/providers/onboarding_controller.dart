
import 'dart:async';

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
  Timer? _debounceTimer;

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

    _debounceTimer = Timer(
      const Duration(milliseconds: 500),
      () {
        saveProgress();
      },
    );
  }

  Future<void> saveProgress() async {
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
  }

  Future<void> nextStep() async {
    final current = state.asData?.value;
    if (current == null) return;

    _debounceTimer?.cancel();

    final nextStep = current.currentStep + 1;

    state = AsyncData((
      data: current.data,
      currentStep: nextStep,
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
    if (current == null) return;

    state = AsyncData((
      data: current.data,
      currentStep: current.currentStep,
      isSaving: current.isSaving,
      isSubmitting: true,
    ));

    try {
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
