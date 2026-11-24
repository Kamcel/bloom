import 'package:bloom/core/theme/app_colors.dart';
import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/features/onboarding/presentation/screens/welcome_scaffold.dart';

import 'package:flutter/material.dart';

class WelcomeScreen3 extends StatelessWidget {
  const WelcomeScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WelcomeLogo(),
          const SizedBox(height: AppSpacing.breathing),
          Text(
            'Pregnancy comes with many emotions, you don’t have to navigate them alone.',
            style: welcomeHeadline(context, long: true),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.softWhite,
                foregroundColor: AppColor.deepPlum,
              ),
              onPressed: () {
                // TODO: context.go(<your auth or onboarding route>)
              },
              child: const Text('Get Started'),
            ),
          ),
        ],
      ),
    );
  }
}
