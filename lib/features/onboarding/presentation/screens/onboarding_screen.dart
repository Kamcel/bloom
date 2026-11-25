import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/core/widgets/app_button.dart';
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

  const OnboardingScreen({super.key, required this.pages, this.onCompleted});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _listenToStepChanges() {
    ref.listen<AsyncValue<OnboardingState>>(onboardingControllerProvider, (
      previous,
      next,
    ) {
      final nextStep = next.asData?.value.currentStep;

      if (nextStep == null) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pageController.hasClients) return;

        final previousStep = previous?.asData?.value.currentStep;

        if (previousStep == null) {
          _pageController.jumpToPage(nextStep);
        } else if (previousStep != nextStep) {
          _pageController.animateToPage(
            nextStep,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        }
      });
    });
  }

  Future<void> _goNextOrFinish(OnboardingState onboardingState) async {
    final controller = ref.read(onboardingControllerProvider.notifier);

    if (onboardingState.isSubmitting) return;

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

  Future<void> _handleBack(OnboardingState onboardingState) async {
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
    final onboardingAsync = ref.watch(onboardingControllerProvider);

    return onboardingAsync.when(
      loading: () => Scaffold(
        backgroundColor: colors.surface,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
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
      ),
      data: (onboardingState) {
        final totalSteps = widget.pages.length;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: colors.surface,
          appBar: OnboardingAppbar(
            currentStep: onboardingState.currentStep + 1,
            totalSteps: totalSteps,
            onBack: () => _handleBack(onboardingState),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    itemCount: widget.pages.length,
                    itemBuilder: (context, index) {
                      return _buildStepContent(index);
                    },
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
                        label:
                            onboardingState.currentStep ==
                                widget.pages.length - 1
                            ? 'Finish'
                            : 'Continue',
                        onPressed: onboardingState.isSubmitting
                            ? null
                            : () => _goNextOrFinish(onboardingState),
                      ),
                      Gap.vMin,
                      TextButton(
                        onPressed: onboardingState.isSubmitting
                            ? null
                            : () => _goNextOrFinish(onboardingState),
                        child: const Text('Skip for now'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
