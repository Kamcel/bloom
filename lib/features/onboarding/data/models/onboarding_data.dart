import 'package:bloom/core/models/dating_method.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_data.freezed.dart';
part 'onboarding_data.g.dart';

@freezed
abstract class OnboardingData with _$OnboardingData {
  const OnboardingData._();

  const factory OnboardingData({
    // Account preference

    // Personal information
    String? name,
    DateTime? dateOfBirth,
    String? country,
    String? state,
    String? city,

    // Pregnancy Information
    DatingMethod? datingMethod,
    DateTime? estimatedDueDate,
    DateTime? lastMensuralPeriod,
    int? pregnancyWeek,
    int? pregnancyDay,

    // Pregnancy history
    bool? isFirstPregnancy,
  }) = _OnboardingData;

  factory OnboardingData.fromJson(Map<String, dynamic> json) =>
      _$OnboardingDataFromJson(json);

  bool get isPersonalInfoValid {
    final hasValidName = name?.trim().isNotEmpty ?? false;
    final dob = dateOfBirth;
    final hasValidDOB = dob != null && !dob.isAfter(DateTime.now());
    final hasValidCountry = country?.trim().isNotEmpty ?? false;
    final hasValidState = state?.trim().isNotEmpty ?? false;
    final hasValidCity = city?.trim().isNotEmpty ?? false;

    return hasValidName &&
        hasValidDOB &&
        hasValidCountry &&
        hasValidState &&
        hasValidCity;
  }
}
