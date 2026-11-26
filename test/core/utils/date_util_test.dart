import 'package:bloom/core/utils/date_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTimeFormatting', () {
    test('dateFormat uses "dd MMM yyyy"', () {
      expect(DateTime(2026, 3, 5).dateFormat(), '05 Mar 2026');
      expect(DateTime(2026, 12, 25).dateFormat(), '25 Dec 2026');
    });

    test('dateOnly strips the time and is UTC', () {
      final d = DateTime(2026, 3, 5, 23, 59).dateOnly;

      expect(d, DateTime.utc(2026, 3, 5));
      expect(d.isUtc, isTrue);
    });

    test('toIsoDate zero-pads month, day and year', () {
      expect(DateTime.utc(2026, 3, 5).toIsoDate(), '2026-03-05');
      expect(DateTime.utc(2026, 11, 25).toIsoDate(), '2026-11-25');
      expect(DateTime.utc(5, 1, 2).toIsoDate(), '0005-01-02');
    });

    test('toIsoDate ignores the time of day', () {
      expect(DateTime(2026, 3, 5, 23, 59).toIsoDate(), '2026-03-05');
    });
  });

  group('parseIsoDate', () {
    test('parses yyyy-MM-dd to UTC midnight', () {
      final d = parseIsoDate('2026-03-05');

      expect(d, DateTime.utc(2026, 3, 5));
      expect(d.isUtc, isTrue);
    });

    test('round-trips with toIsoDate', () {
      final original = DateTime.utc(2027, 2, 9);

      expect(parseIsoDate(original.toIsoDate()), original);
    });

    test('throws FormatException when the shape is wrong', () {
      expect(() => parseIsoDate('2026-03'), throwsFormatException);
      expect(() => parseIsoDate('2026/03/05'), throwsFormatException);
      expect(() => parseIsoDate(''), throwsFormatException);
    });

    test('throws FormatException when a part is not a number', () {
      expect(() => parseIsoDate('2026-ab-05'), throwsFormatException);
    });
  });
}
