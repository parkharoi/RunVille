import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_ville/features/home/domain/run_summary.dart';
import 'package:run_ville/features/home/presentation/home_bottom_controls_layer.dart';
import 'package:run_ville/features/home/presentation/home_hud_layer.dart';
import 'package:run_ville/features/home/presentation/home_map_layer.dart';
import 'package:run_ville/features/home/presentation/home_view_model.dart';
import 'package:run_ville/features/home/presentation/run_summary_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () =>
          ref.read(homeViewModelProvider.notifier).centerMapOnCurrentLocation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewState viewState = ref.watch(homeViewModelProvider);
    final HomeViewModel viewModel = ref.read(homeViewModelProvider.notifier);

    ref.listen<HomeViewState>(homeViewModelProvider, (previous, next) {
      if (previous?.mapCenter != next.mapCenter ||
          previous?.routePoints.length != next.routePoints.length) {
        final double zoom =
            next.routePoints.length > 5 ? _mapController.camera.zoom : 15.5;
        _mapController.move(next.mapCenter, zoom);
      }
    });

    return Scaffold(
      body: Stack(
        children: <Widget>[
          HomeMapLayer(
            mapController: _mapController,
            center: viewState.mapCenter,
            onCenterChanged: viewModel.updateMapCenter,
            routePoints: viewState.routePoints,
            isTracking: !viewState.isPaused,
          ),
          const HomeSkyGradientOverlay(),
          HomeHudLayer(viewState: viewState),
          HomeBottomControlLayer(
            isPaused: viewState.isPaused,
            isMuted: viewState.isMuted,
            mainLabel: _mainActionLabel(viewState),
            onMainPressed: () => _handleMainPressed(viewState, viewModel),
            onMutePressed: viewModel.toggleMuted,
            onStopPressed: () => _openRunSummary(viewState, viewModel),
          ),
        ],
      ),
    );
  }

  Future<void> _handleMainPressed(
    HomeViewState viewState,
    HomeViewModel viewModel,
  ) async {
    if (viewState.isPaused) {
      final bool started = await viewModel.startOrResumeRun();
      if (!started && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('GPS 권한과 위치 서비스가 필요합니다.')));
      }
      return;
    }

    viewModel.pauseRun();
  }

  void _openRunSummary(HomeViewState viewState, HomeViewModel viewModel) {
    if (viewState.runStartCenter == null && viewState.distanceKm == 0) {
      return;
    }

    final RunSummary summary = viewModel.stopRun();
    if (!mounted) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => RunSummaryPage(summary: summary)),
    );
  }

  String _mainActionLabel(HomeViewState viewState) {
    if (!viewState.isPaused) {
      return '일시정지';
    }

    if (viewState.runStartCenter != null || viewState.routePoints.isNotEmpty) {
      return '재개';
    }

    return '시작';
  }
}
