import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:run_ville/core/config/env.dart';

class HomeMapLayer extends StatelessWidget {
  const HomeMapLayer({
    required this.mapController,
    required this.center,
    required this.onCenterChanged,
    required this.routePoints,
    required this.isTracking,
    super.key,
  });

  final MapController mapController;
  final latlng.LatLng center;
  final ValueChanged<latlng.LatLng> onCenterChanged;
  final List<latlng.LatLng> routePoints;
  final bool isTracking;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 14.1,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
        ),
        onPositionChanged: (position, hasGesture) {
          if (hasGesture && !isTracking) {
            onCenterChanged(position.center);
          }
        },
      ),
      children: <Widget>[
        TileLayer(
          urlTemplate: Env.mapTileUrlTemplate,
          userAgentPackageName: Env.mapUserAgentPackageName,
        ),
        if (routePoints.isNotEmpty)
          PolylineLayer(
            polylines: <Polyline>[
              Polyline(
                points: routePoints,
                strokeWidth: 6,
                color: const Color(0xFFFF6F57),
              ),
            ],
          ),
        if (routePoints.isNotEmpty)
          MarkerLayer(
            markers: <Marker>[
              Marker(
                point: routePoints.last,
                width: 44,
                height: 44,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6F57),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_run_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        MarkerLayer(
          markers: <Marker>[
            Marker(
              point: routePoints.isNotEmpty ? routePoints.last : center,
              width: 18,
              height: 18,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF5AD1FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class HomeSkyGradientOverlay extends StatelessWidget {
  const HomeSkyGradientOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 360,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xC43FB8FF),
                Color(0x993FB8FF),
                Color(0x003FB8FF),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
