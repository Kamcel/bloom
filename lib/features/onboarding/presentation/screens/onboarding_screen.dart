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
    return Scaffold(
      appBar: OnboardingAppbar(
        currentStep: 1,
        totalSteps: 5,

        onBack: () => context.pop(),
      ),
    );
  }
}
