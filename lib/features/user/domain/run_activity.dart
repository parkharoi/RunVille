import 'package:flutter/foundation.dart';

@immutable
class RunActivity {
  const RunActivity({
    required this.title,
    required this.date,
    required this.distanceKm,
    required this.avgPace,
    required this.durationMinutes,
    required this.imageUrl,
    required this.isBest,
  });

  final String title;
  final DateTime date;
  final double distanceKm;
  final Duration avgPace;
  final int durationMinutes;
  final String? imageUrl;
  final bool isBest;
}
