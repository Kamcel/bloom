///NB: Edd - Estimated Due Date
///LMP - Last Menstrual Period
int calculateEDDFromLMP({
  required DateTime lastMenstrualPeriod,
  int cycleLength = 28,
}) {
  if (cycleLength < 20 || cycleLength > 40) {
    throw ArgumentError(
      'Invalid cycle length. Please enter a value between 20 and 40 days.',
    );
  }
  final adjustedLMP = cycleLength - 28;
  return lastMenstrualPeriod
      .add(Duration(days: 280 + adjustedLMP))
      .millisecondsSinceEpoch;
}

int calculateGestationalAge(DateTime lastMenstrualPeriod) {
  final currentDate = DateTime.now();
  final gestationalAgeInDays = currentDate
      .difference(lastMenstrualPeriod)
      .inDays;
  return (gestationalAgeInDays ~/ 7).floor(); // Return gestational age in weeks
}

int calculateUltrasoundDate(DateTime lastMenstrualPeriod) {
  final ultrasoundDate = lastMenstrualPeriod.add(
    const Duration(days: 84),
  ); // 12 weeks
  return ultrasoundDate.millisecondsSinceEpoch;
}

int calculateEDDFromUltrasound({
  required DateTime ultrasoundDate,
  required int gestationalWeeks,
  int gestationalDays = 0,
}) {
  if (gestationalWeeks < 0 || gestationalWeeks > 40) {
    throw ArgumentError(
      'Invalid gestational age at ultrasound. Please enter a value between 0 and 40 weeks.',
    );
  }

  if (gestationalDays < 0 || gestationalDays > 6) {
    throw ArgumentError(
      'Invalid gestational days at ultrasound. Please enter a value between 0 and 6 days.',
    );
  }

  final totalGestationalDays = (gestationalWeeks * 7) + gestationalDays;

  if (totalGestationalDays > 280) {
    throw ArgumentError(
      'Total gestational age at ultrasound cannot exceed 40 weeks (280 days).',
    );
  }
  final remainingDays = 280 - totalGestationalDays;
  return ultrasoundDate
      .add(Duration(days: remainingDays))
      .millisecondsSinceEpoch;
}

int calculateTrimester(DateTime lastMenstrualPeriod) {
  final currentDate = DateTime.now();
  final gestationalAgeInDays = currentDate
      .difference(lastMenstrualPeriod)
      .inDays;

  if (gestationalAgeInDays < 0) {
    throw ArgumentError('Last menstrual period cannot be in the future.');
  }

  if (gestationalAgeInDays < 98) {
    // Less than 14 weeks
    return 1; // First trimester
  } else if (gestationalAgeInDays < 196) {
    // Less than 28 weeks
    return 2; // Second trimester
  } else {
    return 3; // Third trimester
  }
}

int calculateWeeksUntilDueDate(DateTime lastMenstrualPeriod) {
  final estimatedDueDate = calculateEDDFromLMP(
    lastMenstrualPeriod: lastMenstrualPeriod,
  );
  final today = DateTime.now();
  final remainingDays = estimatedDueDate.difference(today).inDays;

  if (remainingDays <= 0) {
    return 0; // Due date has passed or is today
  }
  return remainingDays ~/ 7;
}

int calculateEstimatedDueDateFromConception(DateTime conceptionDate) {
  final estimatedDueDate = conceptionDate.add(
    const Duration(days: 266),
  ); // 38 weeks
  return estimatedDueDate.millisecondsSinceEpoch;
}

int calculateEDDFromIVF({
  required DateTime embryoTransferDate,
  required int embryoAgeInDays,
}) {
  if (embryoAgeInDays < 0 || embryoAgeInDays > 6) {
    throw ArgumentError(
      'Invalid embryo age. Please enter a value between 0 and 6 days.',
    );
  }
  return embryoTransferDate
      .add(Duration(days: 266 - embryoAgeInDays))
      .millisecondsSinceEpoch;
}
