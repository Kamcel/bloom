import 'dart:math' as math;

import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/features/onboarding/presentation/screens/welcome_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen2 extends StatelessWidget {
  const WelcomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    // Scales with the screen and leaves room for the heading and button.
    final heroHeight = math.min(h * 0.58, math.max(240.0, h - 360));

    return WelcomeScaffold(
      artwork: Positioned(
        bottom: 0,
        right: 0,
        child: Image.asset(
          'assets/images/bloom_illustration_no_mask.png',
          height: heroHeight,
          fit: BoxFit.fitHeight,
          excludeFromSemantics: true,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WelcomeLogo(),
          const SizedBox(height: AppSpacing.breathing),
          Text(
            'A little more\nsupported, every\nstep of the way',
            style: welcomeHeadline(context),
          ),
          const SizedBox(height: AppSpacing.group),
          WelcomeArrowButton(onPressed: () => context.go('/welcome3')),
        ],
      ),
    );
  }
}
