import 'package:bloom/core/theme/app_colors.dart';
import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/features/onboarding/data/presentation/widgets/onboarding_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class WelcomeScreen1 extends StatelessWidget {
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
            bottom: AppSpacing.standard,
            left: AppSpacing.tight,
            right: AppSpacing.tight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.standard),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    Text(
                      'Welcome to \nBloom',
                      style: textTheme.displayLarge?.copyWith(
                        color: AppColor.softWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: AppSpacing.breathing),
                    OnboardingButton(
                      onPressed: () {
                        context.go('/welcome2');
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
          ),
        ],
      ),
    );
  }
}
