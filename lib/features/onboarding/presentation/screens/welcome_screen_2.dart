import 'package:bloom/core/theme/app_colors.dart';
import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/features/onboarding/presentation/widgets/onboarding_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class WelcomeScreen2 extends StatelessWidget {
  const WelcomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bloom_bg.jpg', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  //  Colors.black54,
                  //   Colors.black87
                ],
                stops: [0.4, 0.75, 1.0],
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.breathing,
            left: AppSpacing.group,
            child: SvgPicture.asset(
              'assets/images/bloom_logo.svg',
              width: 60,
              height: 60,
              colorFilter: const ColorFilter.mode(
                AppColor.softWhite,
                BlendMode.srcIn,
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.breathing * 3,
            left: AppSpacing.tight,
            right: AppSpacing.tight,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.standard),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A little more \nsupported,every\nstep of the way',
                    style: textTheme.displayLarge?.copyWith(
                      color: AppColor.softWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap.vStandard,
                  OnboardingButton(
                    onPressed: () {
                      context.go('/welcome3');
                    },
                    child: PhosphorIcon(
                      Icons.arrow_right_alt,
                      color: AppColor.softWhite,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bloom_illustration_no_mask.png',
              height: 600,
            ),
          ),
        ],
      ),
    );
  }
}
