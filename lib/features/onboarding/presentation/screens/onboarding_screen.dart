import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/core/widgets/app_button.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_questions_page.dart';
import 'package:bloom/features/onboarding/presentation/widgets/onbaording_personal.dart';
import 'package:bloom/features/onboarding/presentation/widgets/onboarding_appbar.dart';
import 'package:bloom/features/onboarding/presentation/widgets/onboarding_expereince.dart';
import 'package:bloom/features/onboarding/presentation/widgets/onboarding_pregnancy.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  final List<OnboardingQuestionsPage> pages;

  const OnboardingScreen({super.key, required this.pages});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  int get _totalSteps => widget.pages.isEmpty ? 1 : widget.pages.length;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNextOrFinish() {
    if (_currentPage < widget.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      // TODO: Navigate to main app / home route
    }
  }

  void _handleBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colors.surface,
      appBar: OnboardingAppbar(
        currentStep: _currentPage + 1,
        totalSteps: _totalSteps,
        onBack: _handleBack,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: widget.pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = widget.pages[index];

                  final Widget stepContent = switch (index) {
                    0 => OnbaordingPersonal(questionsPage: page),
                    1 => OnboardingPregnancy(questionsPage: page),
                    2 => OnboardingExpereince(),
                    _ => OnbaordingPersonal(questionsPage: page),
                  };

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.standard,
                    ),
                    child: stepContent,
                  );
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
                    label: _currentPage == widget.pages.length - 1
                        ? 'Finish'
                        : 'Continue',
                    onPressed: _goNextOrFinish,
                  ),
                  Gap.vMin,
                  TextButton(
                    onPressed: _goNextOrFinish,
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
