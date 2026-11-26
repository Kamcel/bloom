import 'package:bloom/core/models/dating_method.dart';
import 'package:bloom/core/models/dating_result.dart';
import 'package:bloom/core/utils/edd_calculator.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_data.dart';
import 'package:bloom/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:bloom/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_onboarding_repository.dart';
import '../../../helpers/onboarding_test.dart';

// Longer than the controller's 500 ms autosave debounce.
const _pastDebounce = Duration(milliseconds: 700);

void main() {
  late FakeOnboardingRepository repo;
  late ProviderContainer container;

  Future<OnboardingController> start({Progress? progress}) async {
    repo = FakeOnboardingRepository(progress: progress);
    container = ProviderContainer(
      overrides: [onboardingRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    // Keep the auto-dispose provider alive for the whole test.
    container.listen(onboardingControllerProvider, (_, __) {});
    await container.read(onboardingControllerProvider.future);
    return container.read(onboardingControllerProvider.notifier);
  }

  OnboardingState state() =>
      container.read(onboardingControllerProvider).requireValue;

  group('loading', () {
    test('a first-time user starts empty on step 0', () async {
      await start();

      expect(state().data, const OnboardingData());
      expect(state().currentStep, 0);
      expect(state().isSaving, isFalse);
      expect(state().isSubmitting, isFalse);
    });

    test('restores saved answers and step', () async {
      await start(progress: (data: validPersonal(), currentStep: 1));

      expect(state().data, validPersonal());
      expect(state().currentStep, 1);
    });

    test('a saved step past the last one is clamped', () async {
      await start(progress: (data: validPersonal(), currentStep: 9));

      expect(state().currentStep, OnboardingController.totalSteps - 1);
    });

    test('a negative saved step is clamped to 0', () async {
      await start(progress: (data: validPersonal(), currentStep: -3));

      expect(state().currentStep, 0);
    });
  });

  group('personal answers', () {
    test('each update changes only its own field', () async {
      final c = await start();
      final dob = DateTime(1995, 5, 20);

      c.updateName('Amina');
      c.updateDOB(dob);
      c.updateCountry('Nigeria');
      c.updateState('Bauchi');
      c.updateCity('Bauchi');

      expect(state().data.name, 'Amina');
      expect(state().data.dateOfBirth, dob);
      expect(state().data.country, 'Nigeria');
      expect(state().data.state, 'Bauchi');
      expect(state().data.city, 'Bauchi');
    });

    test('changing the country clears state and city', () async {
      final c = await start(progress: (data: validPersonal(), currentStep: 0));

      c.updateCountry('Ghana');

      expect(state().data.country, 'Ghana');
      expect(state().data.state, isNull);
      expect(state().data.city, isNull);
    });

    test('changing the state clears the city but keeps the country', () async {
      final c = await start(progress: (data: validPersonal(), currentStep: 0));

      c.updateState('Kano');

      expect(state().data.country, 'Nigeria');
      expect(state().data.state, 'Kano');
      expect(state().data.city, isNull);
    });
  });

  group('validatePersonalInformation', () {
    late OnboardingController c;
    setUp(() async => c = await start());

    test('null when everything is filled in', () {
      expect(c.validatePersonalInformation(validPersonal()), isNull);
    });

    test('names the first thing that is missing', () {
      final base = validPersonal();

      expect(
        c.validatePersonalInformation(base.copyWith(name: ' ')),
        'Please enter your name.',
      );
      expect(
        c.validatePersonalInformation(base.copyWith(dateOfBirth: null)),
        'Please select your date of birth.',
      );
      expect(
        c.validatePersonalInformation(base.copyWith(country: null)),
        'Please select your country.',
      );
      expect(
        c.validatePersonalInformation(base.copyWith(state: null)),
        'Please select your state.',
      );
      expect(
        c.validatePersonalInformation(base.copyWith(city: null)),
        'Please select your city.',
      );
    });

    test('rejects a date of birth in the future', () {
      final future = DateTime.now().add(const Duration(days: 2));

      expect(
        c.validatePersonalInformation(
          validPersonal().copyWith(dateOfBirth: future),
        ),
        'Date of birth cannot be in the future.',
      );
    });
  });

  group('validatePregnancyInformation', () {
    late OnboardingController c;
    setUp(() async => c = await start());

    final recent = DateTime.now().subtract(const Duration(days: 40));
    OnboardingData base(DatingMethod? m) =>
        validPersonal().copyWith(datingMethod: m);

    test('needs a dating method', () {
      expect(
        c.validatePregnancyInformation(base(null)),
        'Please select how your pregnancy is dated.',
      );
    });

    test('"I do not know" needs nothing else', () {
      expect(
        c.validatePregnancyInformation(base(DatingMethod.unknown)),
        isNull,
      );
    });

    group('last menstrual period', () {
      final lmp = base(DatingMethod.lastMenstrualPeriod);

      test('needs a date', () {
        expect(
          c.validatePregnancyInformation(lmp.copyWith(cyclesRegular: true)),
          'Please enter the first day of your last menstrual period.',
        );
      });

      test('needs to know if cycles are regular', () {
        expect(
          c.validatePregnancyInformation(
            lmp.copyWith(lastMenstrualPeriod: recent),
          ),
          'Please tell us whether your menstrual cycles are regular.',
        );
      });

      test('a regular cycle must be 21-35 days', () {
        final regular = lmp.copyWith(
          lastMenstrualPeriod: recent,
          cyclesRegular: true,
        );

        expect(
          c.validatePregnancyInformation(regular.copyWith(cycleLengthDays: 20)),
          'Please enter a cycle length between 21 and 35 days.',
        );
        expect(
          c.validatePregnancyInformation(regular.copyWith(cycleLengthDays: 36)),
          'Please enter a cycle length between 21 and 35 days.',
        );
        expect(
          c.validatePregnancyInformation(regular.copyWith(cycleLengthDays: 21)),
          isNull,
        );
        expect(
          c.validatePregnancyInformation(regular.copyWith(cycleLengthDays: 35)),
          isNull,
        );
        expect(c.validatePregnancyInformation(regular), isNull);
      });

      test('an irregular cycle skips the length check', () {
        final irregular = lmp.copyWith(
          lastMenstrualPeriod: recent,
          cyclesRegular: false,
          cycleLengthDays: 50,
        );

        expect(c.validatePregnancyInformation(irregular), isNull);
      });

      test('a date in the future is rejected', () {
        final future = lmp.copyWith(
          lastMenstrualPeriod: DateTime.now().add(const Duration(days: 5)),
          cyclesRegular: true,
        );

        expect(
          c.validatePregnancyInformation(future),
          'Please check your pregnancy dating information.',
        );
      });
    });

    test('conception date', () {
      final m = base(DatingMethod.conceptionDate);

      expect(
        c.validatePregnancyInformation(m),
        'Please enter your conception date.',
      );
      expect(
        c.validatePregnancyInformation(m.copyWith(conceptionDate: recent)),
        isNull,
      );
    });

    test('IVF transfer needs a date and an embryo age of 3, 5 or 6', () {
      final m = base(DatingMethod.ivfTransfer);

      expect(
        c.validatePregnancyInformation(m),
        'Please enter your embryo transfer date.',
      );
      expect(
        c.validatePregnancyInformation(m.copyWith(ivfTransferDate: recent)),
        'Embryo age must be 3, 5 or 6 days.',
      );
      expect(
        c.validatePregnancyInformation(
          m.copyWith(ivfTransferDate: recent, ivfEmbryoAgeDays: 4),
        ),
        'Embryo age must be 3, 5 or 6 days.',
      );
      expect(
        c.validatePregnancyInformation(
          m.copyWith(ivfTransferDate: recent, ivfEmbryoAgeDays: 5),
        ),
        isNull,
      );
    });

    test('ultrasound needs a date, weeks, and days between 0 and 6', () {
      final m = base(DatingMethod.ultrasound);

      expect(
        c.validatePregnancyInformation(m),
        'Please enter your ultrasound date.',
      );
      expect(
        c.validatePregnancyInformation(m.copyWith(ultrasoundDate: recent)),
        'Please enter the gestational weeks from your scan.',
      );
      expect(
        c.validatePregnancyInformation(
          m.copyWith(
            ultrasoundDate: recent,
            ultrasoundGestationalWeeks: 8,
            ultrasoundGestationalDays: 7,
          ),
        ),
        'Gestational days must be between 0 and 6.',
      );
      // Days are optional and default to 0.
      expect(
        c.validatePregnancyInformation(
          m.copyWith(ultrasoundDate: recent, ultrasoundGestationalWeeks: 8),
        ),
        isNull,
      );
    });

    test('an impossible scan age is caught by the calculator', () {
      final m = base(DatingMethod.ultrasound)
          .copyWith(ultrasoundDate: recent, ultrasoundGestationalWeeks: 41);

      expect(
        c.validatePregnancyInformation(m),
        'Please check your pregnancy dating information.',
      );
    });

    test('known due date', () {
      final m = base(DatingMethod.knownDueDate);

      expect(
        c.validatePregnancyInformation(m),
        'Please enter your estimated due date.',
      );
      expect(
        c.validatePregnancyInformation(
          m.copyWith(
            knownDueDate: DateTime.now().add(const Duration(days: 90)),
          ),
        ),
        isNull,
      );
    });

    test('provider-confirmed due date', () {
      final m = base(DatingMethod.providerConfirmed);

      expect(
        c.validatePregnancyInformation(m),
        'Please enter the due date confirmed by your healthcare professional.',
      );
      expect(
        c.validatePregnancyInformation(
          m.copyWith(
            providerConfirmedDueDate: DateTime.now().add(
              const Duration(days: 90),
            ),
          ),
        ),
        isNull,
      );
    });
  });

  group('calculateDatingResult', () {
    late OnboardingController c;
    setUp(() async => c = await start());

    final recent = DateTime.now().subtract(const Duration(days: 40));

    test('is null with no method, or "I do not know"', () {
      expect(c.calculateDatingResult(const OnboardingData()), isNull);
      expect(
        c.calculateDatingResult(
          const OnboardingData(datingMethod: DatingMethod.unknown),
        ),
        isNull,
      );
    });

    test('is null while a method is missing its inputs', () {
      expect(
        c.calculateDatingResult(
          const OnboardingData(datingMethod: DatingMethod.lastMenstrualPeriod),
        ),
        isNull,
      );
      expect(
        c.calculateDatingResult(
          OnboardingData(
            datingMethod: DatingMethod.lastMenstrualPeriod,
            lastMenstrualPeriod: recent,
          ),
        ),
        isNull,
        reason: 'cycle regularity is still unanswered',
      );
    });

    test('last menstrual period', () {
      final r = c.calculateDatingResult(
        OnboardingData(
          datingMethod: DatingMethod.lastMenstrualPeriod,
          lastMenstrualPeriod: recent,
          cyclesRegular: true,
        ),
      )!;

      expect(r.edd, dateOnly(recent).add(const Duration(days: 280)));
      expect(r.method, DatingMethod.lastMenstrualPeriod);
    });

    test('conception date', () {
      final r = c.calculateDatingResult(
        OnboardingData(
          datingMethod: DatingMethod.conceptionDate,
          conceptionDate: recent,
        ),
      )!;

      expect(r.edd, dateOnly(recent).add(const Duration(days: 266)));
    });

    test('IVF transfer', () {
      final r = c.calculateDatingResult(
        OnboardingData(
          datingMethod: DatingMethod.ivfTransfer,
          ivfTransferDate: recent,
          ivfEmbryoAgeDays: 5,
        ),
      )!;

      expect(r.edd, dateOnly(recent).add(const Duration(days: 261)));
    });

    test('ultrasound, with days defaulting to 0', () {
      final r = c.calculateDatingResult(
        OnboardingData(
          datingMethod: DatingMethod.ultrasound,
          ultrasoundDate: recent,
          ultrasoundGestationalWeeks: 8,
        ),
      )!;

      expect(r.edd, dateOnly(recent).add(const Duration(days: 280 - 56)));
    });

    test('a due date the user typed in is low confidence with a note', () {
      final due = DateTime.now().add(const Duration(days: 120));

      final r = c.calculateDatingResult(
        OnboardingData(
          datingMethod: DatingMethod.knownDueDate,
          knownDueDate: due,
        ),
      )!;

      expect(r.edd, dateOnly(due));
      expect(r.confidence, DatingConfidence.low);
      expect(r.note, isNotNull);
    });

    test('a provider-confirmed due date is confirmed', () {
      final due = DateTime.now().add(const Duration(days: 120));

      final r = c.calculateDatingResult(
        OnboardingData(
          datingMethod: DatingMethod.providerConfirmed,
          providerConfirmedDueDate: due,
        ),
      )!;

      expect(r.edd, dateOnly(due));
      expect(r.confidence, DatingConfidence.confirmed);
    });
  });

  group('estimatedDueDate', () {
    test('is calculated whenever the answers change', () async {
      final c = await start();
      final lmp = DateTime.now().subtract(const Duration(days: 60));

      c.updateDatingMethod(DatingMethod.lastMenstrualPeriod);
      c.updateLastMenstrualPeriod(lmp);
      expect(
        state().data.estimatedDueDate,
        isNull,
        reason: 'regularity not answered yet',
      );

      c.updateCycleRegularity(true);
      expect(
        state().data.estimatedDueDate,
        dateOnly(lmp).add(const Duration(days: 280)),
      );
    });

    test('is cleared when the method changes to "I do not know"', () async {
      final c = await start();
      c.updateData(validLmp());
      expect(state().data.estimatedDueDate, isNotNull);

      c.updateDatingMethod(DatingMethod.unknown);

      expect(state().data.estimatedDueDate, isNull);
    });

    test('an invalid date does not throw and leaves it empty', () async {
      final c = await start();

      expect(
        () => c.updateData(
          validLmp().copyWith(
            lastMenstrualPeriod: DateTime.now().add(const Duration(days: 10)),
          ),
        ),
        returnsNormally,
      );
      expect(state().data.estimatedDueDate, isNull);
    });

    test('datingResult exposes the current calculation', () async {
      final c = await start();

      expect(c.datingResult, isNull);

      c.updateData(validLmp());

      expect(c.datingResult, isNotNull);
      expect(c.datingResult!.edd, state().data.estimatedDueDate);
    });
  });

  group('autosave', () {
    test('waits for typing to pause, then saves once', () async {
      final c = await start();

      c.updateName('A');
      c.updateName('Am');
      c.updateName('Amina');

      expect(repo.saved, isEmpty, reason: 'nothing saved while typing');

      await Future<void>.delayed(_pastDebounce);

      expect(repo.saved.length, 1);
      expect(repo.saved.single.data.name, 'Amina');
      expect(repo.saved.single.currentStep, 0);
    });

    test('isSaving is false again once the save has finished', () async {
      final c = await start();

      c.updateName('Amina');
      await Future<void>.delayed(_pastDebounce);

      expect(state().isSaving, isFalse);
    });

    test('saveProgress saves the current answers and step', () async {
      final c = await start(progress: (data: validPersonal(), currentStep: 1));

      await c.saveProgress();

      expect(repo.saved.single.data, validPersonal());
      expect(repo.saved.single.currentStep, 1);
    });

    test(
      'overlapping saves are queued, and the last has the latest answers',
      () async {
        final c = await start();

        c.updateName('First');
        final a = c.saveProgress();
        c.updateName('Second');
        final b = c.saveProgress();
        await Future.wait([a, b]);

        expect(repo.saved.length, 2);
        expect(repo.saved.last.data.name, 'Second');
      },
    );
  });

  group('step navigation', () {
    test('nextStep is blocked while personal answers are incomplete', () async {
      final c = await start();
      c.updateName('Amina');

      await c.nextStep();

      expect(state().currentStep, 0);
    });

    test('nextStep moves on and saves the new step', () async {
      final c = await start(progress: (data: validPersonal(), currentStep: 0));

      await c.nextStep();

      expect(state().currentStep, 1);
      expect(repo.saved.last.currentStep, 1);
    });

    test(
      'nextStep is blocked while pregnancy answers are incomplete',
      () async {
        final c = await start(
          progress: (data: validPersonal(), currentStep: 1),
        );

        await c.nextStep();

        expect(state().currentStep, 1);
      },
    );

    test('nextStep moves from pregnancy to the last step when valid', () async {
      final c = await start(progress: (data: validLmp(), currentStep: 1));

      await c.nextStep();

      expect(state().currentStep, 2);
    });

    test('nextStep does nothing on the last step', () async {
      final c = await start(progress: (data: validLmp(), currentStep: 2));

      await c.nextStep();

      expect(state().currentStep, 2);
      expect(repo.saved, isEmpty);
    });

    test('previousStep goes back, saves, and stops at 0', () async {
      final c = await start(progress: (data: validLmp(), currentStep: 1));

      await c.previousStep();
      expect(state().currentStep, 0);
      expect(repo.saved.last.currentStep, 0);

      final savesBefore = repo.saved.length;
      await c.previousStep();
      expect(state().currentStep, 0);
      expect(repo.saved.length, savesBefore);
    });

    test('a pending autosave is replaced by the step save', () async {
      final c = await start();
      c.updateData(validPersonal());

      await c.nextStep();
      await Future<void>.delayed(_pastDebounce);

      expect(repo.saved.length, 1, reason: 'no second save from the old timer');
      expect(repo.saved.single.currentStep, 1);
    });
  });

  group('completeOnboarding', () {
    test('does nothing before the last step', () async {
      final c = await start(progress: (data: validLmp(), currentStep: 1));

      await c.completeOnboarding();

      expect(repo.completeCalls, 0);
    });

    test('does nothing while personal answers are invalid', () async {
      final c = await start(
        progress: (data: validLmp().copyWith(city: null), currentStep: 2),
      );

      await c.completeOnboarding();

      expect(repo.completeCalls, 0);
    });

    test('does nothing while pregnancy answers are invalid', () async {
      final c = await start(progress: (data: validPersonal(), currentStep: 2));

      await c.completeOnboarding();

      expect(repo.completeCalls, 0);
    });

    test('saves the final answers, then completes once', () async {
      final c = await start(progress: (data: validLmp(), currentStep: 2));

      await c.completeOnboarding();

      expect(repo.saved.last.currentStep, 2);
      expect(repo.completeCalls, 1);
      expect(state().isSubmitting, isFalse);
    });

    test('is submitting while in flight and ignores a second call', () async {
      final c = await start(progress: (data: validLmp(), currentStep: 2));
      repo.completeDelay = const Duration(milliseconds: 100);

      final first = c.completeOnboarding();
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(state().isSubmitting, isTrue);

      await c.completeOnboarding();
      await first;

      expect(repo.completeCalls, 1);
      expect(state().isSubmitting, isFalse);
    });

    test('rethrows a failure and stops submitting', () async {
      final c = await start(progress: (data: validLmp(), currentStep: 2));
      repo.completeError = StateError('disk full');

      await expectLater(c.completeOnboarding(), throwsA(isA<StateError>()));

      expect(state().isSubmitting, isFalse);
    });
  });

  group('clearProgress', () {
    test('resets the answers and step and clears storage', () async {
      final c = await start(progress: (data: validLmp(), currentStep: 2));

      await c.clearProgress();

      expect(repo.clearCalls, 1);
      expect(state().data, const OnboardingData());
      expect(state().currentStep, 0);
    });

    test('a pending autosave does not bring the answers back', () async {
      final c = await start();
      c.updateName('Amina');

      await c.clearProgress();
      await Future<void>.delayed(_pastDebounce);

      expect(repo.saved, isEmpty);
    });
  });
}
