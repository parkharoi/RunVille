import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  const UserProfile({
    required this.userId,
    required this.nickname,
    required this.level,
    required this.runnerType,
    required this.profileImageUrl,
    required this.totalDistanceKm,
    required this.totalRunningDays,
    required this.averagePace,
    required this.totalDurationHours,
  });

  final String userId;
  final String nickname;
  final int level;
  final String runnerType; // e.g., "서울 시티러너"
  final String? profileImageUrl;
  final double totalDistanceKm;
  final int totalRunningDays;
  final Duration averagePace;
  final double totalDurationHours;
}
