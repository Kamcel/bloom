import 'package:bloom/core/theme/app_breakpoint.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('width below 600 is compact', () {
    expect(AppBreakpoint.of(0), ScreenSize.compact);
    expect(AppBreakpoint.of(360), ScreenSize.compact);
    expect(AppBreakpoint.of(599.9), ScreenSize.compact);
  });

  test('600 up to 840 is medium', () {
    expect(AppBreakpoint.of(600), ScreenSize.medium);
    expect(AppBreakpoint.of(839.9), ScreenSize.medium);
  });

  test('840 and above is expanded', () {
    expect(AppBreakpoint.of(840), ScreenSize.expanded);
    expect(AppBreakpoint.of(1200), ScreenSize.expanded);
  });
}
