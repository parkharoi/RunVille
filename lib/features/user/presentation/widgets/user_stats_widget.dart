import 'package:flutter/material.dart';

class UserStatsWidget extends StatelessWidget {
  const UserStatsWidget({
    required this.totalDistanceKm,
    required this.totalRunningDays,
    required this.averagePace,
    required this.totalDurationHours,
    super.key,
  });

  final double totalDistanceKm;
  final int totalRunningDays;
  final Duration averagePace;
  final double totalDurationHours;

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes % 60;
    final int seconds = duration.inSeconds % 60;
    return "${duration.inMinutes ~/ 60}'${minutes.toString().padLeft(2, '0')}\"${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '누적 거리',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            '${totalDistanceKm.toStringAsFixed(1)} KM',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: const Color(0xFFFF8C42),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: '총 런닝', value: '$totalRunningDays'),
              _StatItem(label: '평균 페이스', value: _formatDuration(averagePace)),
              _StatItem(
                label: '총 시간',
                value: '${totalDurationHours.toStringAsFixed(0)}h',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
