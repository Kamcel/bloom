import 'package:bloom/core/utils/age_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // calculateAge reads DateTime.now(), so birth dates are built from today.
  final now = DateTime.now();

  test('birthday already happened this year', () {
    final birth = DateTime(now.year - 30, now.month, now.day);

    expect(calculateAge(birth), 30);
  });

  test('birthday is tomorrow, so not yet 30', () {
    final tomorrow = now.add(const Duration(days: 1));
    final birth = DateTime(now.year - 30, tomorrow.month, tomorrow.day);

    expect(calculateAge(birth), 29);
  });

  test('birthday was yesterday, so already 30', () {
    final yesterday = now.subtract(const Duration(days: 1));
    final birth = DateTime(now.year - 30, yesterday.month, yesterday.day);

    expect(calculateAge(birth), 30);
  });

  test('born this year is 0', () {
    expect(calculateAge(DateTime(now.year, 1, 1)), 0);
  });
}
