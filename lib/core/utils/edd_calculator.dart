import 'package:bloom/core/models/dating_method.dart';
import 'package:bloom/core/models/dating_result.dart';

/// All dates are calendar dates held as UTC midnight, so time of day and
/// daylight saving never move a result by a day. Store them in Drift as
/// 'yyyy-MM-dd' text, and keep the method and inputs for recalculation.
const int _fullTermDays = 280; // 40 weeks
const int _conceptionToEddDays = 266; // 38 weeks

DateTime dateOnly(DateTime d) => DateTime.utc(d.year, d.month, d.day);
DateTime _today([DateTime? now]) => dateOnly(now ?? DateTime.now());

class GestationalAge {
  const GestationalAge(this.weeks, this.days);
  final int weeks, days;
  int get totalDays => weeks * 7 + days;
  @override
  String toString() => '${weeks}w ${days}d';
}

/// A due date given by her doctor or midwife.
DatingResult providerConfirmedEdd(DateTime edd) => DatingResult(
  edd: dateOnly(edd),
  method: DatingMethod.providerConfirmed,
  confidence: DatingConfidence.confirmed,
);

/// LMP method. Cycle length only adjusts the date for regular cycles of
/// 21 to 35 days. Otherwise the date is a low-confidence estimate.
DatingResult eddFromLastPeriod({
  required DateTime lastPeriod,
  bool cyclesRegular = true,
  int? cycleLengthDays,
  DateTime? now,
}) {
  final lmp = dateOnly(lastPeriod);
  final today = _today(now);
  if (lmp.isAfter(today)) {
    throw ArgumentError('The last period date cannot be in the future.');
  }
  if (today.difference(lmp).inDays > 300) {
    throw ArgumentError('That date is too long ago for a current pregnancy.');
  }
  final length = cycleLengthDays ?? 28;
  final usable = cyclesRegular && length >= 21 && length <= 35;
  return DatingResult(
    edd: lmp.add(Duration(days: _fullTermDays + (usable ? length - 28 : 0))),
    method: DatingMethod.lastMenstrualPeriod,
    confidence: usable ? DatingConfidence.good : DatingConfidence.low,
    note: usable
        ? null
        : 'When cycles vary, a last-period date can be unreliable. A dating '
              'scan gives a more accurate date, and your midwife or doctor can confirm it.',
  );
}

DatingResult eddFromUltrasound({
  required DateTime scanDate,
  required int gestationalWeeks,
  int gestationalDays = 0,
  DateTime? now,
}) {
  if (gestationalWeeks < 0 || gestationalWeeks > 40) {
    throw ArgumentError('Gestational weeks must be between 0 and 40.');
  }
  if (gestationalDays < 0 || gestationalDays > 6) {
    throw ArgumentError('Gestational days must be between 0 and 6.');
  }
  final ageDays = gestationalWeeks * 7 + gestationalDays;
  if (ageDays > _fullTermDays) {
    throw ArgumentError('Gestational age cannot exceed 40 weeks.');
  }
  final scan = dateOnly(scanDate);
  if (scan.isAfter(_today(now))) {
    throw ArgumentError('The scan date cannot be in the future.');
  }
  return DatingResult(
    edd: scan.add(Duration(days: _fullTermDays - ageDays)),
    method: DatingMethod.ultrasound,
    confidence: DatingConfidence.good,
  );
}

DatingResult eddFromConception(DateTime conceptionDate, {DateTime? now}) {
  final c = dateOnly(conceptionDate);
  if (c.isAfter(_today(now))) {
    throw ArgumentError('The conception date cannot be in the future.');
  }
  return DatingResult(
    edd: c.add(const Duration(days: _conceptionToEddDays)),
    method: DatingMethod.conceptionDate,
    confidence: DatingConfidence.good,
  );
}

DatingResult eddFromIvfTransfer({
  required DateTime transferDate,
  required int embryoAgeDays,
  DateTime? now,
}) {
  if (![3, 5, 6].contains(embryoAgeDays)) {
    throw ArgumentError('Embryo age must be 3, 5 or 6 days.');
  }
  final t = dateOnly(transferDate);
  if (t.isAfter(_today(now))) {
    throw ArgumentError('The transfer date cannot be in the future.');
  }
  return DatingResult(
    edd: t.add(Duration(days: _conceptionToEddDays - embryoAgeDays)),
    method: DatingMethod.ivfTransfer,
    confidence: DatingConfidence.good,
  );
}

// ---- Everything below works from the stored due date, whatever the method ----

int daysUntilDue(DateTime edd, {DateTime? now}) =>
    dateOnly(edd).difference(_today(now)).inDays; // negative = past the date

bool isPastDueDate(DateTime edd, {DateTime? now}) =>
    daysUntilDue(edd, now: now) < 0;

int weeksUntilDue(DateTime edd, {DateTime? now}) {
  final d = daysUntilDue(edd, now: now);
  return d <= 0 ? 0 : d ~/ 7;
}

GestationalAge gestationalAge(DateTime edd, {DateTime? now}) {
  final total = _fullTermDays - daysUntilDue(edd, now: now);
  final days = total < 0 ? 0 : total;
  return GestationalAge(days ~/ 7, days % 7);
}

/// 1 = to 13w6d, 2 = 14w0d to 27w6d, 3 = 28w0d onwards.
int trimester(DateTime edd, {DateTime? now}) {
  final d = gestationalAge(edd, now: now).totalDays;
  return d < 98 ? 1 : (d < 196 ? 2 : 3);
}
