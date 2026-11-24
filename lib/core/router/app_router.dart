import 'package:bloom/core/router/routes.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_questions_page.dart';
import 'package:bloom/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:bloom/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:bloom/features/onboarding/presentation/screens/welcome_screen_1.dart';

import 'package:bloom/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:bloom/features/onboarding/presentation/screens/welcome_screen_2.dart';
import 'package:bloom/features/onboarding/presentation/screens/welcome_screen_3.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter({String? initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation ?? Routes.onboardingScreen,
    routes: [
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(
          imageUrl: 'assets/images/bloom_illustration.png',
          title: 'Bloom',
          description: 'A little more supported, every step of the way',
          description2: 'Pregnancy comes with many emotions. You don\'t have to navigate them alone',
        ),
      ),
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.welcome1,
        builder: (context, state) => const WelcomeScreen1(),
      ),
      GoRoute(
        path: Routes.welcome2,
        builder: (context, state) => const WelcomeScreen2(),
      ),
      GoRoute(
        path: Routes.welcome3,
        builder: (context, state) => const WelcomeScreen3(),
      ),

      GoRoute(
        path: Routes.onboardingScreen,
        builder: (context, state) => const OnboardingScreen(
          pages: [
            OnboardingQuestionsPage(
              title: 'Let\'s get to know you',
              subTitle: 'We\'ll ask you a few questions to personalize your experience',
            ),
            OnboardingQuestionsPage(
              title: 'Your pregnancy journey',
              subTitle: 'We\'ll ask you a few questions to personalize your experience',
            ),
            OnboardingQuestionsPage(
              title: 'Your pregnancy journey',
              subTitle: 'We\'ll ask you a few questions to personalize your experience',
            ),
          ],
        ),
      ),
    ],
  );
}
