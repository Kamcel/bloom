import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  String dateFormat([String? locale]) =>
      DateFormat('dd MMM yyyy', locale).format(this);
}
