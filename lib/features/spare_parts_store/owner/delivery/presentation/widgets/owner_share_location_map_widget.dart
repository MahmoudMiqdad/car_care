// خريطة مشاركة موقع التوصيل — يرسل GPS للمالك كل ١٠ ثوان مع حماية من التداخل.
import 'dart:async';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/spare_parts_store/owner/delivery/presentation/cubit/owner_share_location/owner_share_location_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/delivery/presentation/cubit/owner_share_location/owner_share_location_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

final _ownerOsrmDio = Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
));

class OwnerShareLocationMapWidget extends StatefulWidget {
  const OwnerShareLocationMapWidget({
    super.key,
    required this.orderId,
    this.customerLat,
    this.customerLng,
  });

  final int orderId;
  final double? customerLat;
  final double? customerLng;

  @override
  State<OwnerShareLocationMapWidget> createState() =>
      _OwnerShareLocationMapWidgetState();
}

class _OwnerShareLocationMapWidgetState
    extends State<OwnerShareLocationMapWidget> {
  final MapController _mapController = MapController();
  LatLng? _myLocation;
  List<LatLng> _routePoints = [];
  bool _loadingRoute = false;
  LatLng? _lastRouteFetch;
  bool _isSharing = false;
  bool _isSending = false;
  bool _hasFittedBounds = false;
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
    final ok = await _requestPermission();
    if (!ok) return;
    if (mounted) setState(() => _isSharing = true);
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
      if (mounted) AppSnackBar.error(context, 'صلاحية الموقع مرفوضة');
      return false;
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<void> _sendCurrentLocation() async {
    if (_isSending) return;
    _isSending = true;
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final myLatLng = LatLng(position.latitude, position.longitude);
      if (mounted) {
        setState(() => _myLocation = myLatLng);
        if (kDebugMode) {
          debugPrint(
            '[Owner] current=(${position.latitude}, ${position.longitude})'
            ' | customer=(${widget.customerLat}, ${widget.customerLng})',
          );
        }
        context.read<OwnerShareLocationCubit>().shareLocation(
              orderId: widget.orderId,
              lat: position.latitude,
              lng: position.longitude,
            );
      }
      if (widget.customerLat != null && widget.customerLng != null) {
        await _fetchRoute(
            myLatLng, LatLng(widget.customerLat!, widget.customerLng!));
      }
    } catch (_) {
    } finally {
      _isSending = false;
    }
  }

  Future<void> _fetchRoute(LatLng from, LatLng to) async {
    if (_lastRouteFetch != null) {
      final dist =
          const Distance().as(LengthUnit.Meter, _lastRouteFetch!, from);
      if (dist < 20) return;
    }
    if (_loadingRoute) return;
    if (mounted) setState(() => _loadingRoute = true);
    try {
      final url = 'https://router.project-osrm.org/route/v1/driving/'
          '${from.longitude},${from.latitude};${to.longitude},${to.latitude}'
          '?overview=full&geometries=geojson';
      final response = await _ownerOsrmDio.get<Map<String, dynamic>>(url);
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
            if (!_hasFittedBounds) {
              _hasFittedBounds = true;
              WidgetsBinding.instance.addPostFrameCallback(
                (_) { if (mounted) _fitBounds(); },
              );
            }
          }
        }
      }
    } catch (_) {
      if (mounted && _myLocation != null && widget.customerLat != null) {
        setState(() => _routePoints = [from, to]);
        if (!_hasFittedBounds) {
          _hasFittedBounds = true;
          WidgetsBinding.instance.addPostFrameCallback(
            (_) { if (mounted) _fitBounds(); },
          );
        }
      }
    } finally {
      if (mounted) setState(() => _loadingRoute = false);
    }
  }

  void _fitBounds() {
    final dest = (widget.customerLat != null && widget.customerLng != null)
        ? LatLng(widget.customerLat!, widget.customerLng!)
        : null;
    final points = _routePoints.isNotEmpty
        ? _routePoints
        : [?_myLocation, ?dest];
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
    final dest = (widget.customerLat != null && widget.customerLng != null)
        ? LatLng(widget.customerLat!, widget.customerLng!)
        : null;
    final center = _myLocation ?? dest ?? const LatLng(33.3, 44.4);

    return BlocListener<OwnerShareLocationCubit, OwnerShareLocationState>(
      listener: (context, state) {
        if (kDebugMode) debugPrint('[Owner] POST result: $state');
        if (state is OwnerShareLocationError) {
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
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.car_care.app',
              ),
              if (_routePoints.length > 1)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: AppColors.primary,
                      strokeWidth: 5,
                      borderColor: AppColors.primary.withOpacity(0.3),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              if (_routePoints.isEmpty && _myLocation != null && dest != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [_myLocation!, dest],
                      color: AppColors.primary.withOpacity(0.5),
                      strokeWidth: 3,
                      pattern: StrokePattern.dashed(segments: [6, 4]),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (dest != null)
                    Marker(
                      point: dest,
                      width: 50,
                      height: 60,
                      child: const _CustomerDestinationMarker(),
                    ),
                  if (_myLocation != null)
                    Marker(
                      point: _myLocation!,
                      width: 60,
                      height: 70,
                      child: const _OwnerDeliveryMarker(),
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
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (dest != null)
                  FloatingActionButton.small(
                    heroTag: 'fit_route_owner_share',
                    onPressed: _fitBounds,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.route, color: AppColors.primary),
                  ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'my_loc_owner_share',
                  onPressed: () {
                    if (_myLocation != null) {
                      _mapController.move(_myLocation!, 15);
                    }
                  },
                  backgroundColor: AppColors.primary,
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

class _CustomerDestinationMarker extends StatelessWidget {
  const _CustomerDestinationMarker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.location_pin, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'موقع العميل',
            style: TextStyle(color: Colors.white, fontSize: 9),
          ),
        ),
      ],
    );
  }
}

class _OwnerDeliveryMarker extends StatelessWidget {
  const _OwnerDeliveryMarker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 3,
              ),
            ],
          ),
          child:
              const Icon(Icons.delivery_dining, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'أنت',
            style: TextStyle(color: Colors.white, fontSize: 9),
          ),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.isSharing,
    required this.isLoadingRoute,
    required this.routePoints,
  });

  final bool isSharing;
  final bool isLoadingRoute;
  final List<LatLng> routePoints;

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
                    isSharing
                        ? 'يتم إرسال موقعك للعميل'
                        : 'جاري تحديد الموقع...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSharing
                          ? Colors.green.shade700
                          : Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  if (isLoadingRoute)
                    Text(
                      'جاري حساب المسار...',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600),
                    )
                  else if (distance.isNotEmpty)
                    Text(
                      'المسافة للعميل: $distance',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            BlocBuilder<OwnerShareLocationCubit, OwnerShareLocationState>(
              builder: (context, state) {
                if (state is OwnerShareLocationLoading) {
                  return SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  );
                }
                if (state is OwnerShareLocationSuccess) {
                  return Icon(Icons.cloud_done,
                      color: Colors.green.shade600, size: 18);
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
