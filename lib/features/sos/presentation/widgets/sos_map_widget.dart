// ignore_for_file: deprecated_member_use

import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/loding.dart';

import 'package:car_care/features/sos/presentation/cubit/tracking_cubit/tracking_cubit.dart';
import 'package:car_care/features/sos/presentation/cubit/tracking_cubit/tracking_state.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_waiting_technician_widget.dart';
import 'package:car_care/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

final _osrmDio = Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
));

class SosMapWidget extends StatefulWidget {
  final int sosId;

  const SosMapWidget({super.key, required this.sosId});

  @override
  State<SosMapWidget> createState() => _SosMapWidgetState();
}

class _SosMapWidgetState extends State<SosMapWidget> {
  final MapController _mapController = MapController();
  List<LatLng> _routePoints = [];
  bool _loadingRoute = false;
  LatLng? _lastRouteFetch;

  @override
  void initState() {
    super.initState();
    context.read<TrackingCubit>().loadTracking(widget.sosId);
  }

  Future<void> _goToMyLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _mapController.move(
        LatLng(position.latitude, position.longitude),
        16,
      );
    } catch (e) {
      debugPrint('❌ Location error: $e');
    }
  }

  Future<void> _fetchRoute(LatLng from, LatLng to) async {
    if (_lastRouteFetch != null) {
      final distance = const Distance().as(
        LengthUnit.Meter,
        _lastRouteFetch!,
        from,
      );
      if (distance < 20) return;
    }
    if (_loadingRoute) return;
    setState(() => _loadingRoute = true);

    try {
      final url = 'https://router.project-osrm.org/route/v1/driving/'
          '${from.longitude},${from.latitude};'
          '${to.longitude},${to.latitude}'
          '?overview=full&geometries=geojson';

      final response = await _osrmDio.get<Map<String, dynamic>>(url);

      if (response.statusCode == 200 && response.data != null) {
        final routes = response.data!['routes'] as List<dynamic>?;
        if (routes != null && routes.isNotEmpty) {
          final geometry = routes[0]['geometry'] as Map<String, dynamic>;
          final coordinates = geometry['coordinates'] as List<dynamic>;
          final points = coordinates
              .map((c) => LatLng(
                    (c[1] as num).toDouble(),
                    (c[0] as num).toDouble(),
                  ))
              .toList();
          if (mounted) {
            setState(() {
              _routePoints = points;
              _lastRouteFetch = from;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) setState(() => _routePoints = [from, to]);
    } finally {
      if (mounted) setState(() => _loadingRoute = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingCubit, TrackingState>(
      builder: (context, state) {
        if (state is TrackingWaitingTechnician) {
          return const WaitingTechnicianWidget();
        }

        if (state is TrackingLoading) {
          return const Center(child: AppLoadingWidget());
        }

        if (state is TrackingError) {
          return _buildErrorView(context, state.message);
        }

        if (state is TrackingLoaded) return _buildMap(state);

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off, size: 48, color: AppColors.gray),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () =>
                  context.read<TrackingCubit>().loadTracking(widget.sosId),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(TrackingLoaded state) {
    final data = state.data;

    final userLocation = (data.lat != null && data.lng != null)
        ? LatLng(data.lat!, data.lng!)
        : null;

    final techLocation = state.liveLocation;
    final center = techLocation ?? userLocation ?? const LatLng(33.3, 44.4);

    if (techLocation != null && userLocation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchRoute(techLocation, userLocation);
        _mapController.move(techLocation, _mapController.camera.zoom);
      });
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(initialCenter: center, initialZoom: 14),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.car_care.app',
            ),
            if (data.path != null && data.path!.length > 1)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points:
                        data.path!.map((p) => LatLng(p.lat, p.lng)).toList(),
                    color: AppColors.gray.withOpacity(0.4),
                    strokeWidth: 3,
                    pattern: StrokePattern.dashed(segments: [8, 4]),
                  ),
                ],
              ),
            if (_routePoints.length > 1)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: AppColors.blue,
                    strokeWidth: 5,
                    borderColor: AppColors.blueDark,
                    borderStrokeWidth: 1,
                  ),
                ],
              ),
            if (_routePoints.isEmpty &&
                techLocation != null &&
                userLocation != null)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [techLocation, userLocation],
                    color: AppColors.blue.withOpacity(0.5),
                    strokeWidth: 3,
                    pattern: StrokePattern.dashed(segments: [6, 4]),
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                if (userLocation != null)
                  Marker(
                    point: userLocation,
                    width: 50,
                    height: 50,
                    child: const _UserMarker(),
                  ),
                if (techLocation != null)
                  Marker(
                    point: techLocation,
                    width: 50,
                    height: 50,
                    child: const _TechnicianMarker(),
                  ),
              ],
            ),
          ],
        ),

        Positioned(
          top: 12,
          left: 12,
          right: 12,
          child: _TechnicianInfoCard(
            state: state,
            routePoints: _routePoints,
            isLoadingRoute: _loadingRoute,
          ),
        ),

        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (techLocation != null && userLocation != null)
                FloatingActionButton.small(
                  heroTag: 'fit_route',
                  onPressed: () => _fitRoute(techLocation, userLocation),
                  backgroundColor: AppColors.white,
                  child: Icon(Icons.route, color: AppColors.blueDark),
                ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'my_location',
                onPressed: _goToMyLocation,
                child: const Icon(Icons.my_location),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _fitRoute(LatLng tech, LatLng user) {
    final points = _routePoints.isNotEmpty ? _routePoints : [tech, user];
    if (points.isEmpty) return;
    final bounds = LatLngBounds.fromPoints(points);
    if (bounds.north == bounds.south && bounds.east == bounds.west) {
      _mapController.move(points.first, 15);
      return;
    }
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );
  }
}

// ─── User Marker (موقع المستخدم) ──────────────────────────────────────────
class _UserMarker extends StatelessWidget {
  const _UserMarker();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.red.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(Icons.person_pin, color: AppColors.white, size: 20),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              l10n.you,
              style: TextStyle(color: AppColors.white, fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Technician Marker (موقع الفني) ───────────────────────────────────────
class _TechnicianMarker extends StatefulWidget {
  const _TechnicianMarker();

  @override
  State<_TechnicianMarker> createState() => _TechnicianMarkerState();
}

class _TechnicianMarkerState extends State<_TechnicianMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ScaleTransition(
      scale: _scaleAnim,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.blueDark,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(Icons.build_circle, color: AppColors.white, size: 22),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.blueDark,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                l10n.technician,
                style: TextStyle(color: AppColors.white, fontSize: 9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Status / Info Card ────────────────────────────────────────────────────
class _TechnicianInfoCard extends StatelessWidget {
  final TrackingLoaded state;
  final List<LatLng> routePoints;
  final bool isLoadingRoute;

  const _TechnicianInfoCard({
    required this.state,
    required this.routePoints,
    required this.isLoadingRoute,
  });

  String _getRouteDistance(BuildContext context) {
    final l10n = context.l10n;
    if (routePoints.length < 2) return '';
    double totalMeters = 0;
    final dist = Distance();
    for (int i = 0; i < routePoints.length - 1; i++) {
      totalMeters +=
          dist.as(LengthUnit.Meter, routePoints[i], routePoints[i + 1]);
    }
    if (totalMeters < 1000) {
      return '${totalMeters.toStringAsFixed(0)} ${l10n.meterUnit}';
    }
    return '${(totalMeters / 1000).toStringAsFixed(1)} ${l10n.kmUnit}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLive = state.liveLocation != null;
    final distance = _getRouteDistance(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: isLive ? AppColors.green : AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLive
                        ? l10n.technicianOnWayLiveTracking
                        : l10n.waitingForLocationUpdate,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isLive
                          ? AppColors.green
                          : AppColors.accent,
                      fontSize: 13,
                    ),
                  ),
                  if (isLoadingRoute)
                    Text(
                      l10n.calculatingRoute,
                      style:
                          TextStyle(fontSize: 11, color: AppColors.gray),
                    )
                  else if (distance.isNotEmpty)
                    Text(
                      '${l10n.distanceLabel}: $distance',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.blueDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}