import 'package:bloom/core/models/dating_method.dart';
import 'package:bloom/core/router/app_router.dart';
import 'package:bloom/core/router/routes.dart';
import 'package:bloom/core/utils/date_util.dart';
import 'package:bloom/features/onboarding/data/constants/onboarding_constants.dart';
import 'package:bloom/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:bloom/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:bloom/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_onboarding_repository.dart';
import '../../../helpers/onboarding_test.dart';

// Steps are 0 = personal, 1 = pregnancy, 2 = experience. The tests start from a
// saved step so the heavy country/state/city picker on step 0 is never built.

void _phoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

ProviderContainer _container(FakeOnboardingRepository repo) {
  final container = ProviderContainer(
    overrides: [onboardingRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// Lets the 500 ms autosave timer fire so no timer is left pending.
Future<void> _flushAutosave(WidgetTester tester) =>
    tester.pump(const Duration(seconds: 1));

Future<ProviderContainer> _pumpScreen(
  WidgetTester tester,
  FakeOnboardingRepository repo, {
  VoidCallback? onCompleted,
}) async {
  _phoneScreen(tester);
  final container = _container(repo);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: OnboardingScreen(onCompleted: onCompleted)),
    ),
  );
  await tester.pumpAndSettle();

  return container;
}

OnboardingState _state(ProviderContainer c) =>
    c.read(onboardingControllerProvider).requireValue;

void main() {
  group('titles and subtitles', () {
    // Opening the screen through the real router catches a router that passes
    // its own copy of the page text (the cause of two steps showing the same
    // title).
    for (final step in [1, 2]) {
      testWidgets('step ${step + 1} shows its own text via the router', (
        tester,
      ) async {
        _phoneScreen(tester);
        final repo = FakeOnboardingRepository(
          progress: (data: validLmp(), currentStep: step),
        );
        final container = _container(repo);
        final router = createRouter(initialLocation: Routes.onboardingScreen);
        addTearDown(router.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pumpAndSettle();

        final page = onboardingQuestions[step];
        expect(find.text(page.title), findsOneWidget);
        expect(find.text(page.subTitle), findsOneWidget);

        for (var other = 0; other < onboardingQuestions.length; other++) {
          if (other == step) continue;
          expect(find.text(onboardingQuestions[other].title), findsNothing);
        }

        await _flushAutosave(tester);
      });
    }
  });

  group('resuming', () {
    testWidgets('opens on the saved step', (tester) async {
      final repo = FakeOnboardingRepository(
        progress: (data: validLmp(), currentStep: 2),
      );

      await _pumpScreen(tester, repo);

      expect(find.text(onboardingQuestions[2].title), findsOneWidget);
      expect(find.text('Finish'), findsOneWidget);
    });

    testWidgets('the pregnancy step shows the saved dating method', (
      tester,
    ) async {
      final due = DateTime.now().add(const Duration(days: 100));
      final repo = FakeOnboardingRepository(
        progress: (
          data: validPersonal().copyWith(
            datingMethod: DatingMethod.knownDueDate,
            knownDueDate: due,
          ),
          currentStep: 1,
        ),
      );

      await _pumpScreen(tester, repo);

      expect(find.text('I know my due date'), findsWidgets);
      expect(find.text(due.dateFormat()), findsWidgets);

      await _flushAutosave(tester);
    });
  });

  group('experience step', () {
    testWidgets('choosing an answer saves it to the controller', (
      tester,
    ) async {
      final repo = FakeOnboardingRepository(
        progress: (data: validLmp(), currentStep: 2),
      );
      final container = await _pumpScreen(tester, repo);
      expect(_state(container).data.isFirstPregnancy, isNull);

      await tester.tap(find.text('Yes, this is my first pregnancy'));
      await tester.pump();
      expect(_state(container).data.isFirstPregnancy, isTrue);

      await tester.tap(find.text("No, I've been pregnant before"));
      await tester.pump();
      expect(_state(container).data.isFirstPregnancy, isFalse);

      await _flushAutosave(tester);
      expect(repo.saved.last.data.isFirstPregnancy, isFalse);
    });

    testWidgets('a saved answer is restored', (tester) async {
      final repo = FakeOnboardingRepository(
        progress: (
          data: validLmp().copyWith(isFirstPregnancy: false),
          currentStep: 2,
        ),
      );
      final container = await _pumpScreen(tester, repo);

      expect(_state(container).data.isFirstPregnancy, isFalse);
    });
  });

  group('buttons', () {
    testWidgets('Continue shows the problem and stays put when invalid', (
      tester,
    ) async {
      // Personal answers are fine; no pregnancy dating has been entered.
      final repo = FakeOnboardingRepository(
        progress: (data: validPersonal(), currentStep: 1),
      );
      final container = await _pumpScreen(tester, repo);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(
        find.text('Please enter the first day of your last menstrual period.'),
        findsOneWidget,
      );
      expect(_state(container).currentStep, 1);

      await _flushAutosave(tester);
    });

    testWidgets('Skip for now is checked the same way as Continue', (
      tester,
    ) async {
      final repo = FakeOnboardingRepository(
        progress: (data: validPersonal(), currentStep: 1),
      );
      final container = await _pumpScreen(tester, repo);

      await tester.tap(find.text('Skip for now'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(_state(container).currentStep, 1);

      await _flushAutosave(tester);
    });

    testWidgets('Continue moves to the next step when valid', (tester) async {
      final repo = FakeOnboardingRepository(
        progress: (data: validLmp(), currentStep: 1),
      );
      final container = await _pumpScreen(tester, repo);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(_state(container).currentStep, 2);
      expect(find.text(onboardingQuestions[2].title), findsOneWidget);
      expect(repo.saved.last.currentStep, 2);

      await _flushAutosave(tester);
    });

    testWidgets('Finish completes onboarding and calls onCompleted', (
      tester,
    ) async {
      var completed = 0;
      final repo = FakeOnboardingRepository(
        progress: (data: validLmp(), currentStep: 2),
      );

      await _pumpScreen(tester, repo, onCompleted: () => completed++);

      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      expect(repo.completeCalls, 1);
      expect(completed, 1);
    });

    testWidgets(
      'a failed Finish shows an error and does not call onCompleted',
      (tester) async {
        var completed = 0;
        final repo = FakeOnboardingRepository(
          progress: (data: validLmp(), currentStep: 2),
        )..completeError = StateError('disk full');

        await _pumpScreen(tester, repo, onCompleted: () => completed++);

        await tester.tap(find.text('Finish'));
        await tester.pumpAndSettle();

        expect(
          find.text('We could not save your progress. Please try again.'),
          findsOneWidget,
        );
        expect(completed, 0);
      },
    );
  });
}
