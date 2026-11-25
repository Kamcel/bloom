import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:flutter/material.dart';

class OnboardingExperienceContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool isSelected;
  final VoidCallback? onTap;

  const OnboardingExperienceContainer({
    super.key,
    required this.title,
    required this.subTitle,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.standard),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.standard),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.standard),
          color: isSelected
              ? colors.primaryContainer
              : colors.surfaceContainerLow,
          border: Border.all(
            width: 2,
            color: isSelected ? colors.primary : colors.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                color: isSelected
                    ? colors.onPrimaryContainer
                    : colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap.vMin,
            Text(
              subTitle,
              style: textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? colors.onPrimaryContainer
                    : colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
