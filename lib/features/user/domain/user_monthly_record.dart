import 'package:flutter/foundation.dart';

@immutable
class UserMonthlyRecord {
  const UserMonthlyRecord({
    required this.month,
    required this.year,
    required this.distanceKm,
    required this.isHighlighted,
  });

  final int month; // 1-12
  final int year;
  final double distanceKm;
  final bool isHighlighted; // 강조 표시할지 여부
}
