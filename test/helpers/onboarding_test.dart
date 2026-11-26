import 'package:bloom/core/models/dating_method.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_data.dart';

/// Everything step 1 asks for.
OnboardingData validPersonal() => OnboardingData(
  name: 'Marcel',
  dateOfBirth: DateTime(1995, 5, 20),
  country: 'Nigeria',
  state: 'Plateau',
  city: 'Kanke',
);

/// Personal answers plus a valid last-menstrual-period dating.
OnboardingData validLmp() => validPersonal().copyWith(
  datingMethod: DatingMethod.lastMenstrualPeriod,
  lastMenstrualPeriod: DateTime.now().subtract(const Duration(days: 60)),
  cyclesRegular: true,
  cycleLengthDays: 28,
);
