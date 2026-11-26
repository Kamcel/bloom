import 'package:bloom/core/models/dating_method.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/onboarding_test.dart';

void main() {
  group('isPersonalInfoValid', () {
    test('false for empty data', () {
      expect(const OnboardingData().isPersonalInfoValid, isFalse);
    });

    test('true when every personal answer is present', () {
      expect(validPersonal().isPersonalInfoValid, isTrue);
    });

    test('false when any one personal answer is missing or blank', () {
      final base = validPersonal();

      expect(base.copyWith(name: null).isPersonalInfoValid, isFalse);
      expect(base.copyWith(name: '   ').isPersonalInfoValid, isFalse);
      expect(base.copyWith(dateOfBirth: null).isPersonalInfoValid, isFalse);
      expect(base.copyWith(country: null).isPersonalInfoValid, isFalse);
      expect(base.copyWith(country: ' ').isPersonalInfoValid, isFalse);
      expect(base.copyWith(state: null).isPersonalInfoValid, isFalse);
      expect(base.copyWith(city: null).isPersonalInfoValid, isFalse);
      expect(base.copyWith(city: '').isPersonalInfoValid, isFalse);
    });

    test('false when the date of birth is in the future', () {
      final future = DateTime.now().add(const Duration(days: 2));

      expect(
        validPersonal().copyWith(dateOfBirth: future).isPersonalInfoValid,
        isFalse,
      );
    });
  });

  group('copyWith', () {
    test('passing null clears a field', () {
      final cleared = validPersonal().copyWith(city: null);

      expect(cleared.city, isNull);
      expect(cleared.name, 'Amina');
    });
  });

  group('JSON', () {
    OnboardingData everything() => OnboardingData(
      name: 'Amina',
      dateOfBirth: DateTime(1995, 5, 20),
      country: 'Nigeria',
      state: 'Bauchi',
      city: 'Bauchi',
      datingMethod: DatingMethod.ultrasound,
      lastMenstrualPeriod: DateTime(2026, 5, 1),
      cyclesRegular: false,
      cycleLengthDays: 30,
      conceptionDate: DateTime(2026, 5, 15),
      ivfTransferDate: DateTime(2026, 5, 20),
      ivfEmbryoAgeDays: 5,
      ultrasoundDate: DateTime(2026, 6, 1),
      ultrasoundGestationalWeeks: 8,
      ultrasoundGestationalDays: 3,
      knownDueDate: DateTime(2027, 2, 1),
      providerConfirmedDueDate: DateTime(2027, 2, 3),
      estimatedDueDate: DateTime.utc(2027, 1, 11),
      pregnancyWeek: 10,
      pregnancyDay: 2,
      isFirstPregnancy: true,
    );

    test('every field survives toJson then fromJson', () {
      final data = everything();

      expect(OnboardingData.fromJson(data.toJson()), data);
    });

    test('empty data round-trips', () {
      const data = OnboardingData();

      expect(OnboardingData.fromJson(data.toJson()), data);
    });

    test('the dating method is stored by name', () {
      final json = const OnboardingData(datingMethod: DatingMethod.ivfTransfer)
          .toJson();

      expect(json['datingMethod'], 'ivfTransfer');
    });

    test('unknown keys in saved JSON are ignored', () {
      final json = validPersonal().toJson()..['somethingFromAnOldVersion'] = 1;

      expect(OnboardingData.fromJson(json), validPersonal());
    });

    test('UTC dates stay UTC after a round trip', () {
      final data = OnboardingData(estimatedDueDate: DateTime.utc(2027, 1, 11));

      final restored = OnboardingData.fromJson(data.toJson());

      expect(restored.estimatedDueDate!.isUtc, isTrue);
      expect(restored.estimatedDueDate, DateTime.utc(2027, 1, 11));
    });
  });
}
