import 'package:bloom/core/theme/app_dimension.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final PhosphorIcon? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bool isInteractive = isEnabled && !isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: AppSize.buttonLarge,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.primary.withValues(alpha: 0.5),
          disabledForegroundColor: colors.onPrimary.withValues(alpha: 0.6),
          minimumSize: Size(width ?? double.infinity, AppSize.buttonLarge),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        onPressed: isInteractive ? onPressed : null,
        child: _buildChild(colors, textTheme),
      ),
    );
  }

  Widget _buildChild(ColorScheme colors, TextTheme textTheme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isLoading
          ? SizedBox(
              key: const ValueKey('loading'),
              width: AppSpacing.group - 2,
              height: AppSpacing.group - 2,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colors.onPrimary,
              ),
            )
          : Row(
              key: const ValueKey('content'),
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: textTheme.titleLarge?.copyWith(
                    color: colors.onPrimary,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: AppSpacing.tight),
                  icon!,
                ],
              ],
            ),
    );
  }
}
