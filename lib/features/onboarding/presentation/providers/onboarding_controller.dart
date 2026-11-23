import 'package:bloom/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:bloom/features/onboarding/data/models/onboarding_data.dart';

part 'onboarding_controller.g.dart';

typedef OnboardingState = ({OnboardingData data, int currentStep});

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  Future<OnboardingState> build() async {
    final repository = ref.watch(onboardingRepositoryProvider);

    final progress = await repository.loadProgress();

    if (progress != null) {
      return (data: progress.data, currentStep: progress.currentStep);
    }

    return (data: const OnboardingData(), currentStep: 0);
  }

  Future<void> updateData(OnboardingData data) async {
    final current = state.asData?.value;
    if (current == null) return;

    state = AsyncData((data: data, currentStep: current.currentStep));
  }

  Future<void> saveProgress() async {
    final current = state.asData?.value;
    if (current == null) return;

    final repository = ref.read(onboardingRepositoryProvider);

    await repository.saveProgress(
      data: current.data,
      currentStep: current.currentStep,
    );
  }

  Future<void> nextStep() async {
    final current = state.asData?.value;
    if (current == null) return;

    final nextStep = current.currentStep + 1;

    final repository = ref.read(onboardingRepositoryProvider);

    await repository.saveProgress(data: current.data, currentStep: nextStep);

    state = AsyncData((data: current.data, currentStep: nextStep));
  }

  Future<void> previousStep() async {
    final current = state.asData?.value;
    if (current == null || current.currentStep == 0) return;

    final previousStep = current.currentStep - 1;

    state = AsyncData((data: current.data, currentStep: previousStep));

    await saveProgress();
  }

  Future<void> completeOnboarding() async {
    final repository = ref.read(onboardingRepositoryProvider);
    await repository.completeOnboarding();
  }

  Future<void> clearProgress() async {
    final repository = ref.read(onboardingRepositoryProvider);

    await repository.clearProgress();

    state = AsyncData((data: const OnboardingData(), currentStep: 0));
  }
}
