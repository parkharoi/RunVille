import 'package:flutter/material.dart';
import 'package:run_ville/features/home/presentation/home_formatters.dart';
import 'package:run_ville/features/home/presentation/home_view_model.dart';
import 'package:run_ville/features/home/presentation/widgets/run_ville_brand_header.dart';

class HomeHudLayer extends StatelessWidget {
  const HomeHudLayer({required this.viewState, super.key});

  final HomeViewState viewState;

  @override
  Widget build(BuildContext context) {
    final bool hasStartedRun =
        viewState.runStartCenter != null || viewState.routePoints.isNotEmpty;
    final bool showRunningHud = hasStartedRun;
    final String paceLabel =
        viewState.distanceKm <= 0 ? '--:--' : formatPace(viewState.avgPace);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const RunVilleBrandHeader(compact: true),
            const SizedBox(height: 18),
            if (!showRunningHud)
              _IntroCard(isMuted: viewState.isMuted)
            else ...<Widget>[
              const SizedBox(height: 44),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    viewState.distanceKm.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 94,
                      height: 0.9,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 14),
                    child: Text(
                      'km',
                      style: TextStyle(
                        fontSize: 66,
                        height: 1,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                '현재 누적 거리',
                style: TextStyle(
                  color: Color(0xFF08252F),
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  height: 0.95,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: _MetricItem(
                      label: '진행 시간',
                      value: formatRunDuration(viewState.elapsed),
                    ),
                  ),
                  Expanded(
                    child: _MetricItem(label: '페이스', value: '$paceLabel/km'),
                  ),
                  Expanded(
                    child: _MetricItem(
                      label: '상태',
                      value: viewState.isPaused ? '일시정지' : '추적 중',
                    ),
                  ),
                ],
              ),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.isMuted});

  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0x22FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            isMuted ? '러닝을 시작할 준비가 됐어요' : 'GPS를 켜고 달려보세요',
            style: const TextStyle(
              color: Color(0xFF08252F),
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '시작 버튼을 누르면 현재 위치를 기준으로 거리, 경과 시간, 페이스가 실시간으로 계산됩니다.',
            style: TextStyle(
              color: Color(0xFF34515F),
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF131313),
              fontWeight: FontWeight.w800,
              fontSize: 19,
            ),
          ),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFFFF735A),
              fontWeight: FontWeight.w900,
              fontSize: 42,
              letterSpacing: -1.1,
            ),
          ),
        ),
      ],
    );
  }
}
