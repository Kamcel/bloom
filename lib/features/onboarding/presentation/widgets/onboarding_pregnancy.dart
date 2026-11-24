import 'package:bloom/core/theme/app_colors.dart';
import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:flutter/material.dart';

class EstimatedDueDateCard extends StatelessWidget {
  const EstimatedDueDateCard({
    super.key,
    required this.dueDate,
    this.badgeLabel = 'Estimate',
    this.title = 'Estimated due date',
  });

  final DateTime dueDate;
  final String badgeLabel;
  final String title;

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final cardColor = isDark
        ? const Color(0xFF4F425E)
        : AppColor.softLavender.withValues(alpha: 0.45);
    final borderColor = isDark
        ? AppColor.softLavender.withValues(alpha: 0.25)
        : colors.outlineVariant;
    final badgeColor = isDark
        ? const Color(0xFF282032)
        : AppColor.deepLavender;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.standard),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.tight,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Text(
              badgeLabel,
              style: textTheme.labelMedium?.copyWith(
                color: AppColor.softWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Gap.vMin,
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColor.softWhite.withValues(alpha: 0.85)
                  : colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(dueDate),
            style: textTheme.headlineMedium?.copyWith(
              color: isDark ? AppColor.softWhite : colors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
