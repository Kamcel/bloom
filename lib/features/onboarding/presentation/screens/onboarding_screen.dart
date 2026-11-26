import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/core/widgets/app_button.dart';
import 'package:bloom/features/onboarding/data/constants/onboarding_constants.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_questions_page.dart';
import 'package:bloom/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:bloom/features/onboarding/presentation/widgets/onbaording_personal.dart';
import 'package:bloom/features/onboarding/presentation/widgets/onboarding_appbar.dart';
import 'package:bloom/features/onboarding/presentation/widgets/onboarding_expereince.dart';
import 'package:bloom/features/onboarding/presentation/widgets/onboarding_pregnancy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final List<OnboardingQuestionsPage> pages;
  final VoidCallback? onCompleted;

  // Defaults to the titles/subtitles in onboarding_constants.dart, so the
  // router does not need to (and should not) pass its own copies.
  const OnboardingScreen({
    super.key,
    this.pages = onboardingQuestions,
    this.onCompleted,
  });

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  // Created once the saved step is known, so a returning user lands on it.
  PageController? _pageController;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _listenToStepChanges() {
    // Only fires when the step itself changes, not on every keystroke.
    ref.listen(
      onboardingControllerProvider.select((a) => a.value?.currentStep),
      (previous, next) {
        final pc = _pageController;
        if (next == null || pc == null || !pc.hasClients) return;
        if (pc.page?.round() == next) return;

        pc.animateToPage(
          next,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      },
    );
  }

  Future<void> _goNextOrFinish() async {
    final controller = ref.read(onboardingControllerProvider.notifier);

    // Read at tap time so we always see the latest answers.
    final onboardingState = ref.read(onboardingControllerProvider).value;
    if (onboardingState == null || onboardingState.isSubmitting) return;

    // Validate required information before moving forward.
    final validationError = switch (onboardingState.currentStep) {
      0 => controller.validatePersonalInformation(onboardingState.data),
      1 => controller.validatePregnancyInformation(onboardingState.data),
      _ => null,
    };

    if (validationError != null) {
      _showMessage(validationError);
      return;
    }

    try {
      if (onboardingState.currentStep < OnboardingController.totalSteps - 1) {
        await controller.nextStep();
        return;
      }

      // Page 3 contains optional pregnancy history information.
      await controller.completeOnboarding();

      if (!mounted) return;

      widget.onCompleted?.call();

      if (widget.onCompleted == null) {
        _showMessage('Your onboarding information has been saved.');
      }
    } catch (error) {
      _showMessage('We could not save your progress. Please try again.');
    }
  }

  Future<void> _handleBack() async {
    final onboardingState = ref.read(onboardingControllerProvider).value;
    if (onboardingState == null) return;

    if (onboardingState.currentStep > 0) {
      try {
        await ref.read(onboardingControllerProvider.notifier).previousStep();
      } catch (error) {
        _showMessage('We could not save your progress. Please try again.');
      }
    } else {
      if (context.canPop()) {
        context.pop();
      }
    }
  }

  Widget _buildStepContent(int index) {
    final page = widget.pages[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.standard),
      child: switch (index) {
        0 => OnbaordingPersonal(questionsPage: page),
        1 => OnboardingPregnancy(questionsPage: page),
        2 => OnboardingExperience(questionsPage: page),
        _ => OnbaordingPersonal(questionsPage: page),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _listenToStepChanges();

    final colors = Theme.of(context).colorScheme;

    // Watch only what this screen draws. Watching the whole state rebuilt the
    // screen on every keystroke and on every autosave.
    final view = ref.watch(
      onboardingControllerProvider.select(
        (a) => (
          loaded: a.hasValue,
          failed: a.hasError && !a.hasValue,
          step: a.value?.currentStep ?? 0,
          submitting: a.value?.isSubmitting ?? false,
        ),
      ),
    );

    if (view.failed) {
      return Scaffold(
        backgroundColor: colors.surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.standard),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'We could not load your onboarding progress.',
                  textAlign: TextAlign.center,
                ),
                Gap.vMin,
                TextButton(
                  onPressed: () {
                    ref.invalidate(onboardingControllerProvider);
                  },
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!view.loaded) {
      return Scaffold(
        backgroundColor: colors.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final totalSteps = widget.pages.length;
    final pageController = _pageController ??= PageController(
      initialPage: view.step.clamp(0, totalSteps - 1).toInt(),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colors.surface,
      appBar: OnboardingAppbar(
        currentStep: view.step + 1,
        totalSteps: totalSteps,
        onBack: _handleBack,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                itemCount: totalSteps,
                itemBuilder: (context, index) => _buildStepContent(index),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.standard,
                AppSpacing.tight,
                AppSpacing.standard,
                AppSpacing.tight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    label: view.step == totalSteps - 1 ? 'Finish' : 'Continue',
                    onPressed: view.submitting ? null : _goNextOrFinish,
                  ),
                  Gap.vMin,
                  TextButton(
                    onPressed: view.submitting ? null : _goNextOrFinish,
                    child: const Text('Skip for now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
