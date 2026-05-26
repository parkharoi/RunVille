import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:run_ville/features/home/domain/run_summary.dart';

const latlng.LatLng _defaultMapCenter = latlng.LatLng(37.5665, 126.9780);

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeViewState>(
  HomeViewModel.new,
);

@immutable
class HomeViewState {
  static const Object _unset = Object();

  const HomeViewState({
    required this.mapCenter,
    required this.distanceKm,
    required this.elapsed,
    required this.avgPace,
    required this.isPaused,
    required this.isMuted,
    required this.routePoints,
    this.cadenceSpm = 0,
    this.runStartCenter,
  });

  final latlng.LatLng mapCenter;
  final double distanceKm;
  final Duration elapsed;
  final Duration avgPace;
  final int cadenceSpm;
  final bool isPaused;
  final bool isMuted;
  final List<latlng.LatLng> routePoints;
  final latlng.LatLng? runStartCenter;

  HomeViewState copyWith({
    latlng.LatLng? mapCenter,
    double? distanceKm,
    Duration? elapsed,
    Duration? avgPace,
    int? cadenceSpm,
    bool? isPaused,
    bool? isMuted,
    Object? runStartCenter = _unset,
    Object? routePoints = _unset,
  }) {
    return HomeViewState(
      mapCenter: mapCenter ?? this.mapCenter,
      distanceKm: distanceKm ?? this.distanceKm,
      elapsed: elapsed ?? this.elapsed,
      avgPace: avgPace ?? this.avgPace,
      cadenceSpm: cadenceSpm ?? this.cadenceSpm,
      isPaused: isPaused ?? this.isPaused,
      isMuted: isMuted ?? this.isMuted,
      runStartCenter:
          identical(runStartCenter, _unset)
              ? this.runStartCenter
              : runStartCenter as latlng.LatLng?,
      routePoints:
          identical(routePoints, _unset)
              ? this.routePoints
              : routePoints as List<latlng.LatLng>,
    );
  }
}

class HomeViewModel extends Notifier<HomeViewState> {
  static const LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 0,
  );

  StreamSubscription<Position>? _positionSubscription;
  Timer? _elapsedTimer;
  Position? _lastPosition;
  DateTime? _runStartedAt;
  Duration _accumulatedElapsed = Duration.zero;
  bool _hasActiveRun = false;

  @override
  HomeViewState build() {
    ref.onDispose(_dispose);

    return const HomeViewState(
      mapCenter: _defaultMapCenter,
      distanceKm: 0,
      elapsed: Duration.zero,
      avgPace: Duration.zero,
      isPaused: true,
      isMuted: false,
      routePoints: <latlng.LatLng>[],
    );
  }

  void _dispose() {
    _elapsedTimer?.cancel();
    _positionSubscription?.cancel();
  }

  void updateMapCenter(latlng.LatLng center) {
    if (state.mapCenter == center) {
      return;
    }

    state = state.copyWith(mapCenter: center);
  }

  Future<bool> startOrResumeRun() async {
    if (!_hasActiveRun) {
      final latlng.LatLng? currentLocation = await _resolveCurrentLocation();
      if (currentLocation == null) {
        return false;
      }

      _hasActiveRun = true;
      _lastPosition = null;
      _accumulatedElapsed = Duration.zero;
      _runStartedAt = DateTime.now();

      state = state.copyWith(
        mapCenter: currentLocation,
        distanceKm: 0,
        elapsed: Duration.zero,
        avgPace: Duration.zero,
        isPaused: false,
        runStartCenter: currentLocation,
        routePoints: <latlng.LatLng>[currentLocation],
      );

      _startTrackingStream();
      _startElapsedTimer();
      _refreshComputedMetrics();
      return true;
    }

    if (!state.isPaused) {
      return true;
    }

    _runStartedAt = DateTime.now();
    state = state.copyWith(isPaused: false);
    _startElapsedTimer();
    _refreshComputedMetrics();
    return true;
  }

  void pauseRun() {
    if (_hasActiveRun && !state.isPaused) {
      _accumulatedElapsed = _currentElapsed();
      _runStartedAt = null;
      _elapsedTimer?.cancel();
    }

    state = state.copyWith(isPaused: true);
  }

  void toggleMuted() {
    state = state.copyWith(isMuted: !state.isMuted);
  }

  RunSummary stopRun() {
    if (_hasActiveRun && !state.isPaused) {
      _accumulatedElapsed = _currentElapsed();
    }

    _disposeTracking();

    final HomeViewState snapshot = state.copyWith(
      elapsed: _currentElapsed(),
      avgPace: _currentPace(state.distanceKm),
      isPaused: true,
    );

    state = state.copyWith(
      distanceKm: 0,
      elapsed: Duration.zero,
      avgPace: Duration.zero,
      isPaused: true,
      runStartCenter: null,
      routePoints: const <latlng.LatLng>[],
    );

    _hasActiveRun = false;
    _lastPosition = null;
    _runStartedAt = null;
    _accumulatedElapsed = Duration.zero;

    return RunSummary(
      distanceKm: snapshot.distanceKm,
      elapsed: snapshot.elapsed,
      avgPace: snapshot.avgPace,
      cadenceSpm: snapshot.cadenceSpm,
      startCenter: snapshot.runStartCenter ?? snapshot.mapCenter,
      endCenter: snapshot.mapCenter,
    );
  }

  void _disposeTracking() {
    _elapsedTimer?.cancel();
    _positionSubscription?.cancel();
    _elapsedTimer = null;
    _positionSubscription = null;
  }

  void _startTrackingStream() {
    _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: _locationSettings,
    ).listen(_handlePositionUpdate, onError: (_) {});
  }

  void _startElapsedTimer() {
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _refreshComputedMetrics();
    });
  }

  void _refreshComputedMetrics() {
    final Duration elapsed = _currentElapsed();
    state = state.copyWith(
      elapsed: elapsed,
      avgPace: _currentPace(state.distanceKm),
    );
  }

  Duration _currentElapsed() {
    if (_runStartedAt == null) {
      return _accumulatedElapsed;
    }

    return _accumulatedElapsed + DateTime.now().difference(_runStartedAt!);
  }

  Duration _currentPace(double distanceKm) {
    if (distanceKm <= 0) {
      return Duration.zero;
    }

    final int millisecondsPerKilometer =
        (_currentElapsed().inMilliseconds / distanceKm).round();
    return Duration(milliseconds: millisecondsPerKilometer);
  }

  void _handlePositionUpdate(Position position) {
    final latlng.LatLng currentPoint = latlng.LatLng(
      position.latitude,
      position.longitude,
    );

    if (_lastPosition == null) {
      _lastPosition = position;

      if (_hasActiveRun && !state.isPaused) {
        state = state.copyWith(
          mapCenter: currentPoint,
          routePoints: <latlng.LatLng>[currentPoint],
        );
      }

      return;
    }

    final Position previousPosition = _lastPosition!;
    _lastPosition = position;

    if (state.isPaused) {
      return;
    }

    final double distanceMeters = Geolocator.distanceBetween(
      previousPosition.latitude,
      previousPosition.longitude,
      position.latitude,
      position.longitude,
    );

    state = state.copyWith(
      mapCenter: currentPoint,
      distanceKm: state.distanceKm + (distanceMeters / 1000),
      routePoints: <latlng.LatLng>[...state.routePoints, currentPoint],
    );
    _refreshComputedMetrics();
  }

  Future<void> centerMapOnCurrentLocation() async {
    final latlng.LatLng? currentLocation = await _resolveCurrentLocation();
    if (currentLocation == null) {
      return;
    }

    updateMapCenter(currentLocation);
  }

  Future<latlng.LatLng?> _resolveCurrentLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      );

      return latlng.LatLng(position.latitude, position.longitude);
    } catch (_) {
      return null;
    }
  }
}
