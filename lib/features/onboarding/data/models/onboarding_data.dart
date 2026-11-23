import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_data.freezed.dart';
part 'onboarding_data.g.dart';

enum PregnancyDatingMethod {
  estimatedDueDate,
  lastMenstrualPeriod,
  clinicianProvided,
}

// E -- Entity: OnboardingData represents a description
@freezed
abstract class OnboardingData with _$OnboardingData {
  const OnboardingData._();

  const factory OnboardingData({
    // Account preferance

    // Personal information
    String? name,
    DateTime? dateOfBirth,
    String? country,
    String? state,

    // Pregnancy Information
    PregnancyDatingMethod? pregnancyDatingMethod,
    DateTime? estimatedDueDate,
    DateTime? lastMensuralPeriod,
    int? pregnancyWeek,
    int? pregnancyDay,

    //Pregnancy history
    bool? isFirstPregnancy,
  }) = _OnboardingData;

  factory OnboardingData.fromJson(Map<String, dynamic> json) =>
      _$OnboardingDataFromJson(json);
}
