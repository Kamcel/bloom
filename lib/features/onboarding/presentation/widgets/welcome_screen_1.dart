import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/features/onboarding/presentation/screens/welcome_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen1 extends StatelessWidget {
  const WelcomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WelcomeLogo(),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  'Welcome to\nBloom',
                  style: welcomeHeadline(context),
                ),
              ),
              const SizedBox(width: AppSpacing.standard),
              WelcomeArrowButton(onPressed: () => context.go('/welcome2')),
            ],
          ),
        ],
      ),
    );
  }
}
