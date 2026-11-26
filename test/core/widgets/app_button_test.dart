import 'package:bloom/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

ElevatedButton _button(WidgetTester tester) =>
    tester.widget<ElevatedButton>(find.byType(ElevatedButton));

void main() {
  testWidgets('shows its label and calls onPressed when tapped', (
    tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(AppButton(label: 'Continue', onPressed: () => taps++)),
    );
    await tester.tap(find.text('Continue'));

    expect(taps, 1);
  });

  testWidgets('is disabled when isEnabled is false', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        AppButton(label: 'Continue', isEnabled: false, onPressed: () => taps++),
      ),
    );
    await tester.tap(find.text('Continue'));

    expect(_button(tester).onPressed, isNull);
    expect(taps, 0);
  });

  testWidgets('is disabled when there is no onPressed', (tester) async {
    await tester.pumpWidget(_wrap(const AppButton(label: 'Continue')));

    expect(_button(tester).onPressed, isNull);
  });

  testWidgets('loading shows a spinner, hides the label and ignores taps', (
    tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        AppButton(label: 'Continue', isLoading: true, onPressed: () => taps++),
      ),
    );
    // Let the AnimatedSwitcher finish. pumpAndSettle would never return
    // because the spinner animates forever.
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Continue'), findsNothing);
    expect(_button(tester).onPressed, isNull);
    expect(taps, 0);
  });

  testWidgets('fills the width by default and honours a custom width', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const Align(child: AppButton(label: 'A', width: 120))),
    );
    expect(tester.getSize(find.byType(AppButton)).width, 120);

    await tester.pumpWidget(_wrap(const AppButton(label: 'A')));
    final screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(tester.getSize(find.byType(AppButton)).width, screenWidth);
  });
}
