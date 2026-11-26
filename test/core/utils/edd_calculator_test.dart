import 'package:bloom/core/models/dating_method.dart';
import 'package:bloom/core/models/dating_result.dart';
import 'package:bloom/core/utils/edd_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Every function takes `now`, so these tests never depend on today's date.
  final now = DateTime.utc(2026, 6, 15);

  group('dateOnly', () {
    test('drops the time of day and returns UTC midnight', () {
      final result = dateOnly(DateTime(2026, 3, 5, 23, 59, 59));

      expect(result, DateTime.utc(2026, 3, 5));
      expect(result.isUtc, isTrue);
    });
  });

  group('GestationalAge', () {
    test('totalDays and toString', () {
      const age = GestationalAge(12, 3);

      expect(age.totalDays, 87);
      expect(age.toString(), '12w 3d');
    });
  });

  group('eddFromLastPeriod', () {
    final lmp = DateTime.utc(2026, 5, 1);

    test('regular 28-day cycle adds 280 days', () {
      final r = eddFromLastPeriod(lastPeriod: lmp, now: now);

      expect(r.edd, DateTime.utc(2027, 2, 5));
      expect(r.method, DatingMethod.lastMenstrualPeriod);
      expect(r.confidence, DatingConfidence.good);
      expect(r.note, isNull);
      expect(r.needsConfirmation, isFalse);
    });

    test('regular cycle length shifts the date from the 28-day baseline', () {
      DateTime edd(int length) => eddFromLastPeriod(
        lastPeriod: lmp,
        cycleLengthDays: length,
        now: now,
      ).edd;

      expect(edd(21), DateTime.utc(2027, 1, 29));
      expect(edd(32), DateTime.utc(2027, 2, 9));
      expect(edd(35), DateTime.utc(2027, 2, 12));
    });

    test('cycle length outside 21-35 is ignored and marked low confidence', () {
      for (final length in [20, 36]) {
        final r = eddFromLastPeriod(
          lastPeriod: lmp,
          cycleLengthDays: length,
          now: now,
        );

        expect(r.edd, DateTime.utc(2027, 2, 5), reason: 'length $length');
        expect(r.confidence, DatingConfidence.low);
        expect(r.needsConfirmation, isTrue);
        expect(r.note, isNotNull);
      }
    });

    test('irregular cycles ignore the cycle length and are low confidence', () {
      final r = eddFromLastPeriod(
        lastPeriod: lmp,
        cyclesRegular: false,
        cycleLengthDays: 32,
        now: now,
      );

      expect(r.edd, DateTime.utc(2027, 2, 5));
      expect(r.confidence, DatingConfidence.low);
      expect(r.note, isNotNull);
    });

    test('a time of day on the input does not move the result', () {
      final r = eddFromLastPeriod(
        lastPeriod: DateTime(2026, 5, 1, 23, 30),
        now: now,
      );

      expect(r.edd, DateTime.utc(2027, 2, 5));
    });

    test('rejects a future date', () {
      expect(
        () =>
            eddFromLastPeriod(lastPeriod: DateTime.utc(2026, 6, 16), now: now),
        throwsArgumentError,
      );
    });

    test('accepts today', () {
      expect(
        () => eddFromLastPeriod(lastPeriod: now, now: now),
        returnsNormally,
      );
    });

    test('accepts exactly 300 days ago but rejects 301', () {
      expect(
        () =>
            eddFromLastPeriod(lastPeriod: DateTime.utc(2025, 8, 19), now: now),
        returnsNormally,
      );
      expect(
        () =>
            eddFromLastPeriod(lastPeriod: DateTime.utc(2025, 8, 18), now: now),
        throwsArgumentError,
      );
    });
  });

  group('eddFromUltrasound', () {
    final scan = DateTime.utc(2026, 6, 1);

    test('counts forward from the scan to 40 weeks', () {
      final r = eddFromUltrasound(
        scanDate: scan,
        gestationalWeeks: 8,
        now: now,
      );

      expect(r.edd, DateTime.utc(2027, 1, 11));
      expect(r.method, DatingMethod.ultrasound);
      expect(r.confidence, DatingConfidence.good);
    });

    test('includes gestational days', () {
      final r = eddFromUltrasound(
        scanDate: scan,
        gestationalWeeks: 12,
        gestationalDays: 3,
        now: now,
      );

      expect(r.edd, DateTime.utc(2026, 12, 11));
    });

    test('40w0d on the scan day means the due date is the scan day', () {
      final r = eddFromUltrasound(
        scanDate: scan,
        gestationalWeeks: 40,
        now: now,
      );

      expect(r.edd, scan);
    });

    test('rejects out-of-range weeks and days', () {
      expect(
        () => eddFromUltrasound(scanDate: scan, gestationalWeeks: -1, now: now),
        throwsArgumentError,
      );
      expect(
        () => eddFromUltrasound(scanDate: scan, gestationalWeeks: 41, now: now),
        throwsArgumentError,
      );
      expect(
        () => eddFromUltrasound(
          scanDate: scan,
          gestationalWeeks: 8,
          gestationalDays: 7,
          now: now,
        ),
        throwsArgumentError,
      );
      expect(
        () => eddFromUltrasound(
          scanDate: scan,
          gestationalWeeks: 8,
          gestationalDays: -1,
          now: now,
        ),
        throwsArgumentError,
      );
    });

    test('rejects an age beyond 40 weeks (40w1d)', () {
      expect(
        () => eddFromUltrasound(
          scanDate: scan,
          gestationalWeeks: 40,
          gestationalDays: 1,
          now: now,
        ),
        throwsArgumentError,
      );
    });

    test('rejects a future scan date', () {
      expect(
        () => eddFromUltrasound(
          scanDate: DateTime.utc(2026, 6, 16),
          gestationalWeeks: 8,
          now: now,
        ),
        throwsArgumentError,
      );
    });
  });

  group('eddFromConception', () {
    test('adds 266 days', () {
      final r = eddFromConception(DateTime.utc(2026, 5, 1), now: now);

      expect(r.edd, DateTime.utc(2027, 1, 22));
      expect(r.method, DatingMethod.conceptionDate);
      expect(r.confidence, DatingConfidence.good);
    });

    test('rejects a future date', () {
      expect(
        () => eddFromConception(DateTime.utc(2026, 6, 16), now: now),
        throwsArgumentError,
      );
    });
  });

  group('eddFromIvfTransfer', () {
    final transfer = DateTime.utc(2026, 6, 1);

    test('day 3, 5 and 6 embryos use different offsets', () {
      DateTime edd(int age) => eddFromIvfTransfer(
        transferDate: transfer,
        embryoAgeDays: age,
        now: now,
      ).edd;

      expect(edd(3), DateTime.utc(2027, 2, 19));
      expect(edd(5), DateTime.utc(2027, 2, 17));
      expect(edd(6), DateTime.utc(2027, 2, 16));
    });

    test('reports the IVF method', () {
      final r = eddFromIvfTransfer(
        transferDate: transfer,
        embryoAgeDays: 5,
        now: now,
      );

      expect(r.method, DatingMethod.ivfTransfer);
    });

    test('rejects embryo ages other than 3, 5 or 6', () {
      for (final age in [0, 1, 2, 4, 7]) {
        expect(
          () => eddFromIvfTransfer(
            transferDate: transfer,
            embryoAgeDays: age,
            now: now,
          ),
          throwsArgumentError,
          reason: 'age $age',
        );
      }
    });

    test('rejects a future transfer date', () {
      expect(
        () => eddFromIvfTransfer(
          transferDate: DateTime.utc(2026, 6, 16),
          embryoAgeDays: 5,
          now: now,
        ),
        throwsArgumentError,
      );
    });
  });

  group('providerConfirmedEdd', () {
    test('is confirmed and keeps the date as UTC midnight', () {
      final r = providerConfirmedEdd(DateTime(2026, 12, 25, 14));

      expect(r.edd, DateTime.utc(2026, 12, 25));
      expect(r.method, DatingMethod.providerConfirmed);
      expect(r.confidence, DatingConfidence.confirmed);
      expect(r.needsConfirmation, isFalse);
    });
  });

  group('progress from the due date', () {
    // Helper: a due date that makes the pregnancy exactly [days] days along.
    DateTime eddForAgeDays(int days) =>
        DateTime.utc(2026, 6, 15).add(Duration(days: 280 - days));

    test('daysUntilDue is positive before, zero on, negative after', () {
      expect(daysUntilDue(DateTime.utc(2026, 6, 25), now: now), 10);
      expect(daysUntilDue(now, now: now), 0);
      expect(daysUntilDue(DateTime.utc(2026, 6, 10), now: now), -5);
    });

    test('isPastDueDate is false on the due date itself', () {
      expect(isPastDueDate(now, now: now), isFalse);
      expect(isPastDueDate(DateTime.utc(2026, 6, 14), now: now), isTrue);
      expect(isPastDueDate(DateTime.utc(2026, 6, 16), now: now), isFalse);
    });

    test('weeksUntilDue rounds down and never goes negative', () {
      expect(weeksUntilDue(DateTime.utc(2026, 6, 30), now: now), 2); // 15 days
      expect(weeksUntilDue(DateTime.utc(2026, 6, 21), now: now), 0); // 6 days
      expect(weeksUntilDue(now, now: now), 0);
      expect(weeksUntilDue(DateTime.utc(2026, 6, 1), now: now), 0);
    });

    test('gestationalAge in weeks and days', () {
      final age = gestationalAge(eddForAgeDays(87), now: now);

      expect(age.weeks, 12);
      expect(age.days, 3);
    });

    test('gestationalAge is 0w0d for a due date far in the future', () {
      final age = gestationalAge(DateTime.utc(2028, 1, 1), now: now);

      expect(age.totalDays, 0);
    });

    test('gestationalAge keeps counting past 40 weeks', () {
      final age = gestationalAge(DateTime.utc(2026, 6, 8), now: now);

      expect(age.weeks, 41);
      expect(age.days, 0);
    });

    test('trimester boundaries', () {
      int t(int ageDays) => trimester(eddForAgeDays(ageDays), now: now);

      expect(t(0), 1);
      expect(t(97), 1); // 13w6d
      expect(t(98), 2); // 14w0d
      expect(t(195), 2); // 27w6d
      expect(t(196), 3); // 28w0d
      expect(t(280), 3);
    });
  });
}
