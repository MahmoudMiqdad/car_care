// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';

import 'package:car_care/features/technician_sos/presentation/cubit/share_technician_location_cubit/share_technician_location_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/share_technician_location_cubit/share_technician_location_sos_state.dart';
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

class TechnicianMapWidget extends StatefulWidget {
  final int sosId;
  final double? userLat;
  final double? userLng;

  final String? sosStatus;

  const TechnicianMapWidget({
    super.key,
    required this.sosId,
    this.userLat,
    this.userLng,
    this.sosStatus,
  });

  bool get canShareLocation {
    final status = sosStatus;
    if (status == null) return true;
    return status != 'completed' && status != 'cancelled' &&
        status != 'canceled';
  }

  @override
  State<TechnicianMapWidget> createState() => _TechnicianMapWidgetState();
}

class _TechnicianMapWidgetState extends State<TechnicianMapWidget> {
  final MapController _mapController = MapController();

  LatLng? _myLocation;
  List<LatLng> _routePoints = [];
  bool _loadingRoute = false;
  LatLng? _lastRouteFetch;
  bool _isSharing = false;

  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _startSharingLocation();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  Future<void> _startSharingLocation() async {
    if (!widget.canShareLocation) return;

    final permission = await _requestPermission();
    if (!permission) return;

    setState(() => _isSharing = true);

    await _sendCurrentLocation();

    _locationTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _sendCurrentLocation(),
    );
  }

  Future<bool> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        AppSnackBar.error(context, 'صلاحية الموقع مرفوضة');
      }
      return false;
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<void> _sendCurrentLocation() async {
    if (!widget.canShareLocation) {
      _locationTimer?.cancel();
      return;
    }
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final myLatLng = LatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() => _myLocation = myLatLng);
        _mapController.move(myLatLng, _mapController.camera.zoom);
      }

      if (mounted) {
        context.read<ShareTechnicianLocationSosCubit>().shareLocation(
              sosId: widget.sosId,
              lat: position.latitude,
              lng: position.longitude,
            );
      }

      if (widget.userLat != null && widget.userLng != null) {
        await _fetchRoute(
          myLatLng,
          LatLng(widget.userLat!, widget.userLng!),
        );
      }
    } catch (e) {
      debugPrint('❌ Location error: $e');
    }
  }

  Future<void> _fetchRoute(LatLng from, LatLng to) async {
    if (_lastRouteFetch != null) {
      final distance =
          const Distance().as(LengthUnit.Meter, _lastRouteFetch!, from);
      if (distance < 20) return;
    }

    if (_loadingRoute) return;
    if (mounted) setState(() => _loadingRoute = true);

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
      if (mounted && _myLocation != null && widget.userLat != null) {
        setState(() => _routePoints = [from, to]);
      }
    } finally {
      if (mounted) setState(() => _loadingRoute = false);
    }
  }

  void _fitRoute() {
    final userLocation = (widget.userLat != null && widget.userLng != null)
        ? LatLng(widget.userLat!, widget.userLng!)
        : null;

    final points = _routePoints.isNotEmpty
        ? _routePoints
        : [
            if (_myLocation != null) _myLocation!,
            if (userLocation != null) userLocation,
          ];

    if (points.length < 2) return;

    final bounds = LatLngBounds.fromPoints(points);
    if (bounds.north == bounds.south && bounds.east == bounds.west) {
      _mapController.move(points.first, 15);
      return;
    }

    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = (widget.userLat != null && widget.userLng != null)
        ? LatLng(widget.userLat!, widget.userLng!)
        : null;

    final center = _myLocation ?? userLocation ?? const LatLng(33.3, 44.4);

    return BlocListener<ShareTechnicianLocationSosCubit,
        ShareTechnicianLocationSosState>(
      listener: (context, state) {
        if (state is ShareLocationError) {
          AppSnackBar.error(context, 'خطأ في إرسال الموقع: ${state.message}');
        }
      },
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: center, initialZoom: 14),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.car_care.app',
              ),
              if (_routePoints.length > 1)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: AppColors.carWashTeal,
                      strokeWidth: 5,
                      borderColor: AppColors.carWashTeal.withOpacity(0.3),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              if (_routePoints.isEmpty &&
                  _myLocation != null &&
                  userLocation != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [_myLocation!, userLocation],
                      color: AppColors.carWashTeal.withOpacity(0.5),
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
                  if (_myLocation != null)
                    Marker(
                      point: _myLocation!,
                      width: 50,
                      height: 50,
                      child: const _TechnicianSelfMarker(),
                    ),
                ],
              ),
            ],
          ),

          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: _StatusCard(
              isSharing: _isSharing,
              isLoadingRoute: _loadingRoute,
              routePoints: _routePoints,
              myLocation: _myLocation,
              userLocation: userLocation,
            ),
          ),

          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (userLocation != null)
                  FloatingActionButton.small(
                    heroTag: 'fit_route_tech',
                    onPressed: _fitRoute,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.route, color: AppColors.carWashTeal),
                  ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'my_loc_tech',
                  onPressed: () {
                    if (_myLocation != null) {
                      _mapController.move(_myLocation!, 15);
                    }
                  },
                  backgroundColor: AppColors.carWashTeal,
                  child: const Icon(Icons.my_location, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserMarker extends StatelessWidget {
  const _UserMarker();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.person_pin, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'العميل',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}

class _TechnicianSelfMarker extends StatefulWidget {
  const _TechnicianSelfMarker();

  @override
  State<_TechnicianSelfMarker> createState() => _TechnicianSelfMarkerState();
}

class _TechnicianSelfMarkerState extends State<_TechnicianSelfMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
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
                color: AppColors.carWashTeal,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.carWashTeal.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(Icons.build_circle, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.carWashTeal,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'أنت',
                style: TextStyle(color: Colors.white, fontSize: 9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final bool isSharing;
  final bool isLoadingRoute;
  final List<LatLng> routePoints;
  final LatLng? myLocation;
  final LatLng? userLocation;

  const _StatusCard({
    required this.isSharing,
    required this.isLoadingRoute,
    required this.routePoints,
    required this.myLocation,
    required this.userLocation,
  });

  String _getRouteDistance() {
    if (routePoints.length < 2) return '';
    double totalMeters = 0;
    final dist = Distance();
    for (int i = 0; i < routePoints.length - 1; i++) {
      totalMeters +=
          dist.as(LengthUnit.Meter, routePoints[i], routePoints[i + 1]);
    }
    if (totalMeters < 1000) return '${totalMeters.toStringAsFixed(0)} م';
    return '${(totalMeters / 1000).toStringAsFixed(1)} كم';
  }

  @override
  Widget build(BuildContext context) {
    final distance = _getRouteDistance();

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
                color: isSharing ? Colors.green : Colors.grey,
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
                    isSharing ? 'يتم إرسال موقعك للعميل' : 'جاري تحديد الموقع...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSharing ? Colors.green.shade700 : Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  if (isLoadingRoute)
                    Text(
                      'جاري حساب المسار...',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    )
                  else if (distance.isNotEmpty)
                    Text(
                      'المسافة للعميل: $distance',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.carWashTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            BlocBuilder<ShareTechnicianLocationSosCubit,
                ShareTechnicianLocationSosState>(
              builder: (context, state) {
                if (state is ShareLocationLoading) {
                  return SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.carWashTeal,
                    ),
                  );
                }
                if (state is ShareLocationSuccess) {
                  return Icon(Icons.cloud_done, color: Colors.green.shade600, size: 18);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}