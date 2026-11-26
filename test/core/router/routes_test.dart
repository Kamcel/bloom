import 'package:bloom/core/router/app_router.dart';
import 'package:bloom/core/router/routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  const all = [
    Routes.splash,
    Routes.welcome,
    Routes.welcome1,
    Routes.welcome2,
    Routes.welcome3,
    Routes.onboardingScreen,
  ];

  test('every route is an absolute path and none repeat', () {
    for (final path in all) {
      expect(path, startsWith('/'));
    }
    expect(all.toSet().length, all.length);
  });

  test('the router has a screen for every route constant', () {
    final registered = createRouter().configuration.routes
        .whereType<GoRoute>()
        .map((r) => r.path)
        .toSet();

    for (final path in all) {
      expect(registered, contains(path), reason: '$path has no GoRoute');
    }
  });
}
