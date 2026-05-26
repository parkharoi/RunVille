import 'package:flutter/material.dart';

import '../domain/run_activity.dart';
import '../domain/user_monthly_record.dart';
import '../domain/user_profile.dart';
import 'widgets/activity_card_widget.dart';
import 'widgets/monthly_chart_widget.dart';
import 'widgets/user_header_widget.dart';
import 'widgets/user_stats_widget.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 더미 데이터
    final userProfile = UserProfile(
      userId: '1',
      nickname: '김지춘',
      level: 12,
      runnerType: '서울 시티러너',
      profileImageUrl: null,
      totalDistanceKm: 1284.5,
      totalRunningDays: 142,
      averagePace: const Duration(minutes: 5, seconds: 42),
      totalDurationHours: 112,
    );

    final monthlyRecords = [
      UserMonthlyRecord(
        month: 10,
        year: 2025,
        distanceKm: 95.5,
        isHighlighted: false,
      ),
      UserMonthlyRecord(
        month: 11,
        year: 2025,
        distanceKm: 102.3,
        isHighlighted: false,
      ),
      UserMonthlyRecord(
        month: 12,
        year: 2025,
        distanceKm: 85.0,
        isHighlighted: false,
      ),
      UserMonthlyRecord(
        month: 1,
        year: 2026,
        distanceKm: 110.5,
        isHighlighted: false,
      ),
      UserMonthlyRecord(
        month: 2,
        year: 2026,
        distanceKm: 125.0,
        isHighlighted: true,
      ),
      UserMonthlyRecord(
        month: 3,
        year: 2026,
        distanceKm: 98.2,
        isHighlighted: false,
      ),
      UserMonthlyRecord(
        month: 4,
        year: 2026,
        distanceKm: 88.0,
        isHighlighted: false,
      ),
    ];

    final activities = [
      RunActivity(
        title: '발렌타인 러닝 아트',
        date: DateTime(2026, 2, 14),
        distanceKm: 5.24,
        avgPace: const Duration(minutes: 5, seconds: 23),
        durationMinutes: 28 * 60 + 15,
        imageUrl: null,
        isBest: true,
      ),
      RunActivity(
        title: '한강 공원 코스',
        date: DateTime(2026, 2, 12),
        distanceKm: 8.20,
        avgPace: const Duration(minutes: 4, seconds: 51),
        durationMinutes: 45 * 60 + 12,
        imageUrl: null,
        isBest: false,
      ),
      RunActivity(
        title: '남산 둘레길',
        date: DateTime(2026, 2, 10),
        distanceKm: 12.5,
        avgPace: const Duration(minutes: 5, seconds: 30),
        durationMinutes: 60 * 60 + 8,
        imageUrl: null,
        isBest: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('프로필'), centerTitle: true, elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 유저 헤더
            UserHeaderWidget(userProfile: userProfile),
            const Divider(height: 32),
            // 통계
            UserStatsWidget(
              totalDistanceKm: userProfile.totalDistanceKm,
              totalRunningDays: userProfile.totalRunningDays,
              averagePace: userProfile.averagePace,
              totalDurationHours: userProfile.totalDurationHours,
            ),
            const SizedBox(height: 24),
            // 월간 차트
            MonthlyChartWidget(monthlyRecords: monthlyRecords),
            const SizedBox(height: 24),
            // 오늘의 러닝 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '오늘의 러닝',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            ActivityCardWidget(activity: activities[0]),
            // 최근 활동 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                '최근 활동',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ...activities.skip(1).map((activity) {
              return ActivityCardWidget(activity: activity);
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
