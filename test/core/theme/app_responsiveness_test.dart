import 'package:bloom/core/theme/app_breakpoint.dart';
import 'package:bloom/core/theme/app_responsiveness.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Responsive', () {
    test('size flags follow the width', () {
      expect(const Responsive(400).isCompact, isTrue);
      expect(const Responsive(700).isMedium, isTrue);
      expect(const Responsive(900).isExpanded, isTrue);
      expect(const Responsive(700).size, ScreenSize.medium);
    });

    test('value() picks per size and falls back to the smaller one', () {
      expect(
        const Responsive(400).value(compact: 'c', medium: 'm', expanded: 'e'),
        'c',
      );
      expect(
        const Responsive(700).value(compact: 'c', medium: 'm', expanded: 'e'),
        'm',
      );
      expect(
        const Responsive(900).value(compact: 'c', medium: 'm', expanded: 'e'),
        'e',
      );

      // Missing values fall back: expanded -> medium -> compact.
      expect(const Responsive(900).value(compact: 'c', medium: 'm'), 'm');
      expect(const Responsive(900).value(compact: 'c'), 'c');
      expect(const Responsive(700).value(compact: 'c'), 'c');
    });

    test('screenPadding and contentMaxWidth per size', () {
      expect(const Responsive(400).screenPadding, 20);
      expect(const Responsive(700).screenPadding, 32);
      expect(const Responsive(900).screenPadding, 48);

      expect(const Responsive(400).contentMaxWidth, double.infinity);
      expect(const Responsive(700).contentMaxWidth, 560);
      expect(const Responsive(900).contentMaxWidth, 640);
    });
  });

  group('ResponsiveBody', () {
    Future<void> pumpAt(
      WidgetTester tester,
      double width, {
      bool padding = true,
      required Key childKey,
    }) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveBody(
              padding: padding,
              child: Container(key: childKey, height: 10),
            ),
          ),
        ),
      );
    }

    testWidgets('phone: full width minus 20px padding each side', (
      tester,
    ) async {
      const key = Key('child');
      await pumpAt(tester, 400, childKey: key);

      expect(tester.getSize(find.byKey(key)).width, 360);
    });

    testWidgets('small tablet: capped at 560 with 32px padding', (
      tester,
    ) async {
      const key = Key('child');
      await pumpAt(tester, 700, childKey: key);

      expect(tester.getSize(find.byKey(key)).width, 496); // 560 - 2 * 32
    });

    testWidgets('padding: false removes the side padding', (tester) async {
      const key = Key('child');
      await pumpAt(tester, 700, padding: false, childKey: key);

      expect(tester.getSize(find.byKey(key)).width, 560);
    });
  });

  group('AppResponsiveness.wrap', () {
    Future<double> effectiveScale(
      WidgetTester tester, {
      required double system,
      required double user,
    }) async {
      var captured = 0.0;

      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(system)),
          child: Builder(
            builder: (context) => AppResponsiveness.wrap(
              context,
              Builder(
                builder: (inner) {
                  captured = MediaQuery.of(inner).textScaler.scale(1);
                  return const SizedBox();
                },
              ),
              userTextScale: user,
            ),
          ),
        ),
      );

      return captured;
    }

    testWidgets('multiplies the system scale by the user scale', (
      tester,
    ) async {
      expect(
        await effectiveScale(tester, system: 1.2, user: 1.2),
        closeTo(1.44, 0.001),
      );
    });

    testWidgets('never goes above 1.6', (tester) async {
      expect(await effectiveScale(tester, system: 2.0, user: 1.0), 1.6);
    });

    testWidgets('never goes below 0.9', (tester) async {
      expect(await effectiveScale(tester, system: 1.0, user: 0.5), 0.9);
    });
  });
}
