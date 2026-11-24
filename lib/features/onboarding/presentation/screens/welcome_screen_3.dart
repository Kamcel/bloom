import 'package:bloom/core/theme/app_colors.dart';
import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen3 extends StatelessWidget {
  const WelcomeScreen3({super.key});

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
                colors: [Colors.transparent, Colors.black87],
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
              child: Text(
                'Pregnancy comes with many emotions, you don\'t have to navigate them alone',
                style: textTheme.displayLarge?.copyWith(
                  color: AppColor.softWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: AppSpacing.standard,
            left: AppSpacing.standard,
            right: AppSpacing.standard,
            child: SafeArea(
              child: AppButton(
                label: 'Get Started',
                onPressed: () => context.go('/onboardingScreen'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
