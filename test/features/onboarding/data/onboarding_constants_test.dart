import 'package:bloom/features/onboarding/data/constants/onboarding_constants.dart';
import 'package:bloom/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('there is one page per controller step', () {
    expect(onboardingQuestions.length, OnboardingController.totalSteps);
  });

  test('no page has an empty title or subtitle', () {
    for (final page in onboardingQuestions) {
      expect(page.title.trim(), isNotEmpty);
      expect(page.subTitle.trim(), isNotEmpty);
    }
  });

  // Guards against the pages showing the same text twice.
  test('every page has its own title and subtitle', () {
    final titles = onboardingQuestions.map((p) => p.title).toSet();
    final subtitles = onboardingQuestions.map((p) => p.subTitle).toSet();

    expect(titles.length, onboardingQuestions.length);
    expect(subtitles.length, onboardingQuestions.length);
  });

  test('the experience question is written as a question', () {
    expect(onboardingQuestions[2].title, endsWith('?'));
  });
}
