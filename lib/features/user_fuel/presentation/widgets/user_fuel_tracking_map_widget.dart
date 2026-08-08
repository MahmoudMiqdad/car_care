
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/location_helper.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_tracking_cubit/user_fuel_tracking_cubit.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_tracking_cubit/user_fuel_tracking_state.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

final _osrmDio = Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
));

class UserFuelTrackingMapWidget extends StatefulWidget {
  final int orderId;
  final double? userLat;
  final double? userLng;

  const UserFuelTrackingMapWidget({
    super.key,
    required this.orderId,
    this.userLat,
    this.userLng,
  });

  @override
  State<UserFuelTrackingMapWidget> createState() =>
      _UserFuelTrackingMapWidgetState();
}

class _UserFuelTrackingMapWidgetState
    extends State<UserFuelTrackingMapWidget> {
  final MapController _mapController = MapController();
  List<LatLng> _routePoints = [];
  bool _loadingRoute = false;
  LatLng? _lastRouteFetch;

  @override
  void initState() {
    super.initState();
    context.read<UserFuelTrackingCubit>().loadTracking(widget.orderId);
  }

  Future<void> _goToMyLocation() async {
    // Uses the shared guard so GPS-off / denied permission surface a clear
    // Arabic message instead of doing nothing.
    final location = await getCurrentLocation();
    if (!mounted) return;

    if (!location.isSuccess) {
      AppSnackBar.error(context, location.errorMessage!);
      return;
    }

    final position = location.position!;
    _mapController.move(LatLng(position.latitude, position.longitude), 16);
  }

  Future<void> _fetchRoute(LatLng from, LatLng to) async {
    if (_lastRouteFetch != null) {
      final distance =
          const Distance().as(LengthUnit.Meter, _lastRouteFetch!, from);
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
    } catch (_) {
      if (mounted) setState(() => _routePoints = [from, to]);
    } finally {
      if (mounted) setState(() => _loadingRoute = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFuelTrackingCubit, UserFuelTrackingState>(
      builder: (context, state) {
        if (state is UserFuelTrackingLoading) {
          return const Center(child: AppLoadingWidget());
        }

        if (state is UserFuelTrackingError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => context
                        .read<UserFuelTrackingCubit>()
                        .loadTracking(widget.orderId),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is UserFuelTrackingLoaded) {
          return _buildMap(state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMap(UserFuelTrackingLoaded state) {
    final userLocation = (widget.userLat != null && widget.userLng != null)
        ? LatLng(widget.userLat!, widget.userLng!)
        : null;

    final providerLocation = state.liveLocation;
    final center = providerLocation ?? userLocation ?? const LatLng(33.3, 44.4);

    if (providerLocation != null && userLocation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchRoute(providerLocation, userLocation);
        _mapController.move(providerLocation, _mapController.camera.zoom);
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
            if (_routePoints.length > 1)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: Colors.blue.shade600,
                    strokeWidth: 5,
                    borderColor: Colors.blue.shade900,
                    borderStrokeWidth: 1,
                  ),
                ],
              ),
            if (_routePoints.isEmpty &&
                providerLocation != null &&
                userLocation != null)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [providerLocation, userLocation],
                    color: Colors.blue.withOpacity(0.5),
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
                    child: const Icon(Icons.location_pin,
                        color: Colors.red, size: 40),
                  ),
                if (providerLocation != null)
                  Marker(
                    point: providerLocation,
                    width: 50,
                    height: 50,
                    child: Icon(Icons.local_gas_station,
                        color: Colors.blue.shade700, size: 36),
                  ),
              ],
            ),
          ],
        ),
        // Successful response but the provider has not posted a location yet.
        // This is not an error — polling continues and the banner disappears
        // as soon as a location arrives.
        if (providerLocation == null)
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_searching,
                      color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'لم يشارك مزود الوقود موقعه بعد',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.small(
            heroTag: 'user_fuel_my_location',
            onPressed: _goToMyLocation,
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}