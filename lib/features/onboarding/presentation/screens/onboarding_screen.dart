import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/core/widgets/app_button.dart';
import 'package:bloom/features/onboarding/presentation/widgets/onboarding_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: OnboardingAppbar(
        currentStep: 1,
        totalSteps: 5,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.standard,
                ),
                child: Column(
                  children: [
                    Container(height: 600, color: Colors.red),
                    Gap.vGroup,
                  ],
                ),
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
                    label: 'Continue',
                    onPressed: () {},
                  ),
                  Gap.vMin,
                  TextButton(
                    onPressed: () {},
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
