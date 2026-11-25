import 'package:bloom/core/models/dating_method.dart';

/// `low` means: show it as an estimate and prompt for a scan or confirmation.
enum DatingConfidence { confirmed, good, low }

class DatingResult {
  const DatingResult({
    required this.edd,
    required this.method,
    required this.confidence,
    this.note,
  });
  final DateTime edd;
  final DatingMethod method;
  final DatingConfidence confidence;
  final String? note;
  bool get needsConfirmation => confidence == DatingConfidence.low;
}
