import 'dart:async';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/fuel_provider/share_location_fuel/presentation/cubit/share_location_fuel_cubit.dart';
import 'package:car_care/features/fuel_provider/share_location_fuel/presentation/cubit/share_location_fuel_state.dart';
import 'package:car_care/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

final _osrmDio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

class FuelProviderMapWidget extends StatefulWidget {
  final int orderId;
  final double? userLat;
  final double? userLng;

  final String? orderStatus;

  const FuelProviderMapWidget({
    super.key,
    required this.orderId,
    this.userLat,
    this.userLng,
    this.orderStatus,
  });

  bool get canShareLocation {
    final status = orderStatus?.toLowerCase();
    if (status == null) return true;
    return status != 'completed' &&
        status != 'delivered' &&
        status != 'cancelled' &&
        status != 'canceled';
  }

  @override
  State<FuelProviderMapWidget> createState() => _FuelProviderMapWidgetState();
}

class _FuelProviderMapWidgetState extends State<FuelProviderMapWidget> {
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
    final l10n = context.l10n;

    if (!widget.canShareLocation) {
      if (mounted) {
        AppSnackBar.error(context, l10n.cannotShareLocationOrderFinished);
      }
      return;
    }

    final ready = await _ensureLocationReady();
    if (!ready) return;

    if (mounted) setState(() => _isSharing = true);

    await _sendCurrentLocation();

    _locationTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _sendCurrentLocation(),
    );
  }

  Future<bool> _ensureLocationReady() async {
    final l10n = context.l10n;

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        AppSnackBar.error(context, l10n.enableLocationServiceMessage);
      }
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        AppSnackBar.error(context, l10n.locationPermissionDeniedForever);
      }
      return false;
    }

    if (permission == LocationPermission.denied) {
      if (mounted) {
        AppSnackBar.error(context, l10n.locationPermissionRequired);
      }
      return false;
    }

    return true;
  }

  Future<void> _sendCurrentLocation() async {
    final l10n = context.l10n;

    if (!widget.canShareLocation) {
      _locationTimer?.cancel();
      if (mounted) setState(() => _isSharing = false);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final myLatLng = LatLng(position.latitude, position.longitude);

      if (!mounted) return;

      setState(() => _myLocation = myLatLng);
      _mapController.move(myLatLng, _mapController.camera.zoom);

      context.read<ShareFuelProviderLocationCubit>().shareLocation(
        orderId: widget.orderId,
        lat: position.latitude,
        lng: position.longitude,
      );

      if (widget.userLat != null && widget.userLng != null) {
        await _fetchRoute(myLatLng, LatLng(widget.userLat!, widget.userLng!));
      }
    } catch (e) {
      debugPrint('❌ Location error: $e');
      if (mounted) {
        AppSnackBar.error(context, l10n.unableToDetermineLocation);
      }
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
    if (mounted) setState(() => _loadingRoute = true);

    try {
      final url =
          'https://router.project-osrm.org/route/v1/driving/'
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
              .map(
                (c) =>
                    LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
              )
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

    return BlocListener<
      ShareFuelProviderLocationCubit,
      ShareFuelProviderLocationState
    >(
      listener: (context, state) {
        if (state is ShareFuelProviderLocationError) {
          final l10n = context.l10n;
          final msg =
              state.message.isEmpty || state.message.startsWith('Instance of')
              ? l10n.genericErrorTryAgain
              : state.message;
          AppSnackBar.error(context, '${l10n.errorSendingLocation}: $msg');
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
                      child: const _DestinationMarker(),
                    ),
                  if (_myLocation != null)
                    Marker(
                      point: _myLocation!,
                      width: 60,
                      height: 60,
                      child: const _ProviderSelfMarker(),
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
                if (userLocation != null)
                  FloatingActionButton.small(
                    heroTag: 'fit_route_provider',
                    onPressed: _fitRoute,
                    backgroundColor: context.colorScheme.surfaceContainer,
                    child: Icon(Icons.route, color: AppColors.carWashTeal),
                  ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'my_loc_provider',
                  onPressed: () {
                    if (_myLocation != null) {
                      _mapController.move(_myLocation!, 15);
                    }
                  },
                  backgroundColor: AppColors.carWashTeal,
                  child: Icon(Icons.my_location, color: AppColors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DestinationMarker extends StatelessWidget {
  const _DestinationMarker();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent,
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(Icons.location_pin, color: AppColors.white, size: 20),
        ),
        const SizedBox(height: 2),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              l10n.deliveryLocation,
              style: TextStyle(color: AppColors.white, fontSize: 9),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProviderSelfMarker extends StatefulWidget {
  const _ProviderSelfMarker();

  @override
  State<_ProviderSelfMarker> createState() => _ProviderSelfMarkerState();
}

class _ProviderSelfMarkerState extends State<_ProviderSelfMarker>
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
    _scaleAnim = Tween<double>(
      begin: 0.92,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.carWashTeal,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.carWashTeal.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Icon(
              Icons.local_gas_station,
              color: AppColors.white,
              size: 22,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.carWashTeal,
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

class _StatusCard extends StatelessWidget {
  final bool isSharing;
  final bool isLoadingRoute;
  final List<LatLng> routePoints;

  const _StatusCard({
    required this.isSharing,
    required this.isLoadingRoute,
    required this.routePoints,
  });

  String _getRouteDistance(BuildContext context) {
    final l10n = context.l10n;
    if (routePoints.length < 2) return '';
    double totalMeters = 0;
    final dist = Distance();
    for (int i = 0; i < routePoints.length - 1; i++) {
      totalMeters += dist.as(
        LengthUnit.Meter,
        routePoints[i],
        routePoints[i + 1],
      );
    }
    if (totalMeters < 1000) {
      return '${totalMeters.toStringAsFixed(0)} ${l10n.meterUnit}';
    }
    return '${(totalMeters / 1000).toStringAsFixed(1)} ${l10n.kmUnit}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                color: isSharing
                    ? AppColors.green
                    : context.colorScheme.outlineVariant,
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
                        ? l10n.sharingLocationWithCustomer
                        : l10n.determiningLocation,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSharing
                          ? AppColors.green
                          : context.colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                  if (isLoadingRoute)
                    Text(
                      l10n.calculatingRoute,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    )
                  else if (distance.isNotEmpty)
                    Text(
                      '${l10n.distanceToCustomer}: $distance',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.carWashTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            BlocBuilder<
              ShareFuelProviderLocationCubit,
              ShareFuelProviderLocationState
            >(
              builder: (context, state) {
                if (state is ShareFuelProviderLocationLoading) {
                  return SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.carWashTeal,
                    ),
                  );
                }
                if (state is ShareFuelProviderLocationSuccess) {
                  return Icon(
                    Icons.cloud_done,
                    color: AppColors.green,
                    size: 18,
                  );
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
