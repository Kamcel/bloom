import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  String dateFormat([String? locale]) =>
      DateFormat('dd MMM yyyy', locale).format(this);

  DateTime get dateOnly => DateTime.utc(year, month, day);

  String toIsoDate() {
    final d = dateOnly;
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}

DateTime parseIsoDate(String isoDate) {
  final parts = isoDate.split('-');
  if (parts.length != 3) {
    throw FormatException('Invalid ISO date format: $isoDate');
  }
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final day = int.parse(parts[2]);
  return DateTime.utc(year, month, day);
}
