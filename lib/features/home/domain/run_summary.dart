import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart' as latlng;

@immutable
class RunSummary {
  const RunSummary({
    required this.distanceKm,
    required this.elapsed,
    required this.avgPace,
    required this.cadenceSpm,
    required this.startCenter,
    required this.endCenter,
  });

  final double distanceKm;
  final Duration elapsed;
  final Duration avgPace;
  final int cadenceSpm;
  final latlng.LatLng startCenter;
  final latlng.LatLng endCenter;
}
