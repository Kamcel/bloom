import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_questions_page.freezed.dart';
part 'onboarding_questions_page.g.dart';

// E -- Entity: ClassName represents a description
@freezed
abstract class OnboardingQuestionsPage with _$OnboardingQuestionsPage {
  const OnboardingQuestionsPage._();

  const factory OnboardingQuestionsPage({
    required String title,
    required String subTitle,
  }) = _OnboardingQuestionsPage;
}
