import 'package:bloom/core/models/dating_method.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_data.freezed.dart';
part 'onboarding_data.g.dart';

@freezed
abstract class OnboardingData with _$OnboardingData {
  const OnboardingData._();

  const factory OnboardingData({
    // Personal information
    String? name,
    DateTime? dateOfBirth,
    String? country,
    String? state,
    String? city,

    // Pregnancy dating method
    DatingMethod? datingMethod,

    // Last menstrual period
    DateTime? lastMenstrualPeriod,
    bool? cyclesRegular,
    int? cycleLengthDays,

    // Conception
    DateTime? conceptionDate,

    // IVF
    DateTime? ivfTransferDate,
    int? ivfEmbryoAgeDays,

    // Ultrasound
    DateTime? ultrasoundDate,
    int? ultrasoundGestationalWeeks,
    int? ultrasoundGestationalDays,

    // Due date supplied by the user
    DateTime? knownDueDate,

    // Due date confirmed by a healthcare professional
    DateTime? providerConfirmedDueDate,

    // Calculated result
    DateTime? estimatedDueDate,

    // Retained for existing pregnancy information
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
