import 'package:flutter/material.dart';

import '../../domain/user_monthly_record.dart';

class MonthlyChartWidget extends StatefulWidget {
  const MonthlyChartWidget({required this.monthlyRecords, super.key});

  final List<UserMonthlyRecord> monthlyRecords;

  @override
  State<MonthlyChartWidget> createState() => _MonthlyChartWidgetState();
}

class _MonthlyChartWidgetState extends State<MonthlyChartWidget> {
  late String selectedRange;

  @override
  void initState() {
    super.initState();
    selectedRange = '월간';
  }

  @override
  Widget build(BuildContext context) {
    // 최대 거리 계산
    final double maxDistance =
        widget.monthlyRecords.fold(
          0.0,
          (max, record) => record.distanceKm > max ? record.distanceKm : max,
        ) +
        10;

    return Column(
      children: [
        // 탭 선택
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                ['주간', '월간', '연간', '전체'].map((range) {
                  final isSelected = selectedRange == range;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRange = range;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFFFF8C42)
                                : const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        range,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
        // 차트
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:
                      widget.monthlyRecords.map((record) {
                        final barHeight =
                            (record.distanceKm / maxDistance) * 100;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 24,
                              height: barHeight,
                              decoration: BoxDecoration(
                                color:
                                    record.isHighlighted
                                        ? const Color(0xFFFF8C42)
                                        : const Color(0xFFB3E5FC),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getMonthAbbr(record.month),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getMonthAbbr(int month) {
    const monthAbbrs = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return monthAbbrs[month - 1];
  }
}
