import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:run_ville/features/home/domain/run_summary.dart';
import 'package:run_ville/features/home/presentation/home_formatters.dart';

class RunSummaryPage extends StatefulWidget {
  const RunSummaryPage({required this.summary, super.key});

  final RunSummary summary;

  @override
  State<RunSummaryPage> createState() => _RunSummaryPageState();
}

class _RunSummaryPageState extends State<RunSummaryPage> {
  String? _startLocationName;

  @override
  void initState() {
    super.initState();
    _resolveLocationNames();
  }

  Future<void> _resolveLocationNames() async {
    try {
      final List<gc.Placemark> startPlacemarks = await gc
          .placemarkFromCoordinates(
            widget.summary.startCenter.latitude,
            widget.summary.startCenter.longitude,
          );

      if (mounted) {
        setState(() {
          _startLocationName = _formatPlacemark(startPlacemarks.first);
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _startLocationName = '복현동';
        });
      }
    }
  }

  String _formatPlacemark(gc.Placemark p) {
    final String administrativeArea = p.administrativeArea ?? '';
    final String subAdministrativeArea = p.subAdministrativeArea ?? '';
    final String locality = p.locality ?? '';
    final String thoroughfare = p.thoroughfare ?? '';

    if (subAdministrativeArea.isNotEmpty) {
      return '$administrativeArea $subAdministrativeArea';
    }
    if (locality.isNotEmpty) {
      return '$administrativeArea $locality';
    }
    if (thoroughfare.isNotEmpty) {
      return '$administrativeArea $thoroughfare';
    }

    if (locality.isNotEmpty) {
      return locality;
    }

    return '복현동';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text('러닝 종료'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xFFFF745B), Color(0xFFFFA06F)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      '기록이 저장됐어요',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${widget.summary.distanceKm.toStringAsFixed(1)} km',
                      style:
                          theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.2,
                          ) ??
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '달린 시간 ${formatRunDuration(widget.summary.elapsed)} · 평균 페이스 ${formatPace(widget.summary.avgPace)}/km',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _DetailCard(
                title: '케이던스',
                value: '${widget.summary.cadenceSpm} spm',
                subtitle: '분당 걸음 수 기준으로 러닝 리듬을 보여줘요.',
              ),
              const SizedBox(height: 14),
              _DetailCard(
                title: '달린 기록',
                value: '${widget.summary.distanceKm.toStringAsFixed(1)} km',
                subtitle: '총 거리와 시간을 함께 확인할 수 있어요.',
              ),
              const SizedBox(height: 14),
              _LocationRangeCard(startName: _startLocationName),
              const SizedBox(height: 14),
              _DetailCard(
                title: '전체 요약',
                value:
                    '${formatRunDuration(widget.summary.elapsed)} · ${formatPace(widget.summary.avgPace)}/km',
                subtitle: '정지 버튼을 눌렀을 때의 최종 러닝 기록입니다.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF51606E),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationRangeCard extends StatelessWidget {
  const _LocationRangeCard({required this.startName});

  final String? startName;

  @override
  Widget build(BuildContext context) {
    final String displayStartName = startName ?? '복현동';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '출발지',
            style: TextStyle(
              color: Color(0xFF51606E),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            displayStartName,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '출발지 기준 동네명으로 저장됐어요.',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
