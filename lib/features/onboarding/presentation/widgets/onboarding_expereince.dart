import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_questions_page.dart';
import 'package:bloom/features/onboarding/presentation/widgets/onboarding_experience_container.dart';
import 'package:flutter/material.dart';

class OnboardingExperience extends StatefulWidget {
  final OnboardingQuestionsPage questionsPage;
  final ValueChanged<bool>? onChanged;

  const OnboardingExperience({
    super.key,
    required this.questionsPage,
    this.onChanged,
  });

  @override
  State<OnboardingExperience> createState() => _OnboardingExperienceState();
}

class _OnboardingExperienceState extends State<OnboardingExperience> {
  bool? _isFirstPregnancy;

  void _selectOption(bool value) {
    setState(() => _isFirstPregnancy = value);
    widget.onChanged?.call(value);
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
