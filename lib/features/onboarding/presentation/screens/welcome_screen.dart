import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/widgets/app_button.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class WelcomeScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String? description2;

  const WelcomeScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    this.description2,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.standard),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: FittedBox(
                    child: Image.asset(
                      'assets/images/bloom_illustruation.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
                //Image.asset(imageUrl, width: 300, height: 300),
                const SizedBox(height: AppSpacing.breathing - 8),
                Text(
                  title,
                  style: textTheme.displayLarge?.copyWith(
                    color: colors.primary,
                    fontSize: 64,
                  ),
                ),
                const SizedBox(height: AppSpacing.tight),
                Text(
                  description,
                  style: textTheme.bodyLarge?.copyWith(color: colors.secondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.group),
                Text(
                  description2 ?? '',
                  style: textTheme.bodyMedium?.copyWith(color: colors.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.breathing * 2),
                AppButton(
                  label: 'Begin your Journey',
                  icon: PhosphorIcon(PhosphorIcons.arrowRight),
                ),
                const SizedBox(height: AppSpacing.tight - 4),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: colors.primary),
                  onPressed: () => context.go('/onboardingScreen'),
                  child: Text('I already have an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
