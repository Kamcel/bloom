import 'package:bloom/core/router/routes.dart';
import 'package:bloom/core/theme/app_dimension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final bool showSkip;
  final VoidCallback? onSkip;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.showBack,
    this.onBack,
    required this.showSkip,
    this.onSkip,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final List<Widget> allActions = [
      if (showSkip)
        TextButton(
          onPressed: onSkip,
          child: Text('Skip', style: textTheme.bodyLarge),
        ),
      ...?actions,
    ];

    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBack ? _buildBackButton(context) : null,
      title: Text(title, style: textTheme.titleLarge),
      actions: allActions.isNotEmpty ? allActions : null,
      leadingWidth: 100,
    );
  }

  Widget _buildBackButton(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return TextButton(
      onPressed:
          onBack ??
          () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.welcome);
            }
          },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(PhosphorIcons.arrowLeft, color: colors.primary),
          const SizedBox(width: AppSpacing.tight),
          Text('Back', style: textTheme.bodyLarge),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
