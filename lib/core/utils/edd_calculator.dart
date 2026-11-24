
/// EDD - Estimated Due Date
/// LMP - Last Menstrual Period

/// Calculates EDD using the LMP method.
/// Assumes a regular menstrual cycle.
DateTime calculateEDDFromLMP({
  required DateTime lastMenstrualPeriod,
  int cycleLength = 28,
}) {
  if (cycleLength < 20 || cycleLength > 40) {
    throw ArgumentError(
      'Invalid cycle length. Enter a value between 20 and 40 days.',
    );
  }

  final adjustedLMP = cycleLength - 28;

  return lastMenstrualPeriod.add(
    Duration(days: 280 + adjustedLMP),
  );
}

/// Calculates completed gestational weeks from LMP.
int calculateGestationalAge(DateTime lastMenstrualPeriod) {
  final today = DateTime.now();

  if (lastMenstrualPeriod.isAfter(today)) {
    throw ArgumentError('LMP cannot be in the future.');
  }

  final gestationalAgeInDays =
      today.difference(lastMenstrualPeriod).inDays;

  return gestationalAgeInDays ~/ 7;
}

/// Calculates the date corresponding to 12 weeks from LMP.
DateTime calculateDateAt12Weeks(DateTime lastMenstrualPeriod) {
  return lastMenstrualPeriod.add(
    const Duration(days: 84),
  );
}

/// Calculates EDD using ultrasound gestational age.
DateTime calculateEDDFromUltrasound({
  required DateTime ultrasoundDate,
  required int gestationalWeeks,
  int gestationalDays = 0,
}) {
  if (gestationalWeeks < 0 || gestationalWeeks > 40) {
    throw ArgumentError(
      'Gestational weeks must be between 0 and 40.',
    );
  }

  if (gestationalDays < 0 || gestationalDays > 6) {
    throw ArgumentError(
      'Gestational days must be between 0 and 6.',
    );
  }

  final totalGestationalDays =
      (gestationalWeeks * 7) + gestationalDays;

  if (totalGestationalDays > 280) {
    throw ArgumentError(
      'Gestational age cannot exceed 40 weeks.',
    );
  }

  final remainingDays = 280 - totalGestationalDays;

  return ultrasoundDate.add(
    Duration(days: remainingDays),
  );
}

/// Determines the current trimester using LMP.
int calculateTrimester(DateTime lastMenstrualPeriod) {
  final today = DateTime.now();

  if (lastMenstrualPeriod.isAfter(today)) {
    throw ArgumentError('LMP cannot be in the future.');
  }

  final gestationalAgeInDays =
      today.difference(lastMenstrualPeriod).inDays;

  if (gestationalAgeInDays < 98) {
    return 1;
  } else if (gestationalAgeInDays < 196) {
    return 2;
  } else {
    return 3;
  }
}

/// Calculates remaining whole weeks until EDD.
int calculateWeeksUntilDueDate({
  required DateTime lastMenstrualPeriod,
  int cycleLength = 28,
}) {
  final estimatedDueDate = calculateEDDFromLMP(
    lastMenstrualPeriod: lastMenstrualPeriod,
    cycleLength: cycleLength,
  );

  final today = DateTime.now();

  final remainingDays = estimatedDueDate
      .difference(DateTime(today.year, today.month, today.day))
      .inDays;

  if (remainingDays <= 0) {
    return 0;
  }

  return remainingDays ~/ 7;
}

/// Calculates EDD from conception date (38 weeks).
DateTime calculateEDDFromConception(DateTime conceptionDate) {
  return conceptionDate.add(
    const Duration(days: 266),
  );
}

/// Calculates EDD from IVF embryo transfer date.
DateTime calculateEDDFromIVF({
  required DateTime embryoTransferDate,
  required int embryoAgeInDays,
}) {
  if (![3, 5, 6].contains(embryoAgeInDays)) {
    throw ArgumentError(
      'Embryo age must be 3, 5, or 6 days.',
    );
  }

  return embryoTransferDate.add(
    Duration(days: 266 - embryoAgeInDays),
  );
}
