import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_questions_page.dart';
import 'package:bloom/features/onboarding/presentation/widgets/onboarding_experience_container.dart';
import 'package:bloom/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingExperience extends ConsumerStatefulWidget {
  final OnboardingQuestionsPage questionsPage;

  const OnboardingExperience({super.key, required this.questionsPage});

  @override
  ConsumerState<OnboardingExperience> createState() =>
      _OnboardingExperienceState();
}

class _OnboardingExperienceState extends ConsumerState<OnboardingExperience> {
  bool? _isFirstPregnancy;

  @override
  void initState() {
    super.initState();
    // Restore the saved answer.
    _isFirstPregnancy = ref
        .read(onboardingControllerProvider)
        .value
        ?.data
        .isFirstPregnancy;
  }

  void _selectOption(bool value) {
    setState(() => _isFirstPregnancy = value);
    ref.read(onboardingControllerProvider.notifier).updateFirstPregnancy(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.questionsPage.title.isNotEmpty) ...[
          Text(
            widget.questionsPage.title,
            style: textTheme.headlineLarge?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap.vMin,
        ],
        if (widget.questionsPage.subTitle.isNotEmpty) ...[
          Text(
            widget.questionsPage.subTitle,
            style: textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
          Gap.vGroup,
        ],
        OnboardingExperienceContainer(
          title: 'Yes, this is my first pregnancy',
          subTitle: "Every step is new. We'll take each one gently, together.",
          isSelected: _isFirstPregnancy == true,
          onTap: () => _selectOption(true),
        ),
        Gap.vGroup,
        OnboardingExperienceContainer(
          title: "No, I've been pregnant before",
          subTitle: "Every pregnancy is different. We'll meet you exactly where you are.",
          isSelected: _isFirstPregnancy == false,
          onTap: () => _selectOption(false),
        ),
      ],
    );
  }
}
