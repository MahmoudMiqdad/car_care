import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/presentation/cubit/customer_delivery_tracking/customer_delivery_tracking_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/presentation/cubit/customer_delivery_tracking/customer_delivery_tracking_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

final _customerOsrmDio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

class CustomerDeliveryTrackingMapWidget extends StatefulWidget {
  const CustomerDeliveryTrackingMapWidget({
    super.key,
    required this.orderId,
    this.customerLat,
    this.customerLng,
  });

  final int orderId;
  final double? customerLat;
  final double? customerLng;

  @override
  State<CustomerDeliveryTrackingMapWidget> createState() =>
      _CustomerDeliveryTrackingMapWidgetState();
}

class _CustomerDeliveryTrackingMapWidgetState
    extends State<CustomerDeliveryTrackingMapWidget> {
  final MapController _mapController = MapController();
  List<LatLng> _routePoints = [];
  bool _loadingRoute = false;
  LatLng? _lastRouteFetch;
  bool _hasFittedBounds = false;

  @override
  void initState() {
    super.initState();
    context.read<CustomerDeliveryTrackingCubit>().loadTracking(widget.orderId);
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
      _mapController.move(LatLng(position.latitude, position.longitude), 16);
    } catch (_) {}
  }

  void _fitBoundsToPoints(List<LatLng> points) {
    if (points.length < 2) return;
    final bounds = LatLngBounds.fromPoints(points);
    if (bounds.north == bounds.south && bounds.east == bounds.west) {
      _mapController.move(points.first, 15);
      return;
    }
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
    );
  }

  Future<void> _fetchRoute(LatLng from, LatLng to) async {
    if (_lastRouteFetch != null) {
      final dist = const Distance().as(
        LengthUnit.Meter,
        _lastRouteFetch!,
        from,
      );
      if (dist < 20) return;
    }
    if (_loadingRoute) return;
    setState(() => _loadingRoute = true);
    try {
      final url =
          'https://router.project-osrm.org/route/v1/driving/'
          '${from.longitude},${from.latitude};${to.longitude},${to.latitude}'
          '?overview=full&geometries=geojson';
      final response = await _customerOsrmDio.get<Map<String, dynamic>>(url);
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
            if (!_hasFittedBounds) {
              _hasFittedBounds = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _fitBoundsToPoints(_routePoints);
              });
            }
          }
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _routePoints = [from, to]);
        if (!_hasFittedBounds) {
          _hasFittedBounds = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _fitBoundsToPoints([from, to]);
          });
        }
      }
    } finally {
      if (mounted) setState(() => _loadingRoute = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      CustomerDeliveryTrackingCubit,
      CustomerDeliveryTrackingState
    >(
      builder: (context, state) {
        if (state is CustomerDeliveryTrackingLoading) {
          return const Center(child: AppLoadingWidget());
        }
        if (state is CustomerDeliveryTrackingError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 48,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => context
                        .read<CustomerDeliveryTrackingCubit>()
                        .loadTracking(widget.orderId),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is CustomerDeliveryTrackingWaiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delivery_dining_outlined,
                    size: 64,
                    color: AppColors.primary.withOpacity(0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'في انتظار بدء التوصيل...',
                    style: context.textTheme.labelLarge!.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        if (state is CustomerDeliveryTrackingEnded) {
          final isDelivered = state.status == 'delivered';
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isDelivered
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    size: 64,
                    color: isDelivered ? AppColors.green : AppColors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isDelivered ? 'تم التوصيل بنجاح' : 'انتهى التتبع',
                    style: context.textTheme.labelLarge!.copyWith(
                      color: isDelivered ? AppColors.green : AppColors.red,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        if (state is CustomerDeliveryTrackingLoaded) {
          return _buildMap(state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMap(CustomerDeliveryTrackingLoaded state) {
    final customerLocation =
        (widget.customerLat != null && widget.customerLng != null)
        ? LatLng(widget.customerLat!, widget.customerLng!)
        : null;
    final deliveryLocation = state.deliveryLocation;
    final center =
        deliveryLocation ?? customerLocation ?? const LatLng(33.3, 44.4);

    if (deliveryLocation != null && customerLocation != null) {
      if (kDebugMode) {
        debugPrint(
          '[Customer] delivery=(${deliveryLocation.latitude}, ${deliveryLocation.longitude})'
          ' | customer=(${customerLocation.latitude}, ${customerLocation.longitude})',
        );
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _fetchRoute(deliveryLocation, customerLocation);
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
                    color: AppColors.primary,
                    strokeWidth: 5,
                    borderColor: AppColors.primary.withOpacity(0.3),
                    borderStrokeWidth: 1,
                  ),
                ],
              ),
            if (_routePoints.isEmpty &&
                deliveryLocation != null &&
                customerLocation != null)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [deliveryLocation, customerLocation],
                    color: AppColors.primary.withOpacity(0.5),
                    strokeWidth: 3,
                    pattern: StrokePattern.dashed(segments: [6, 4]),
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                if (customerLocation != null)
                  Marker(
                    point: customerLocation,
                    width: 50,
                    height: 60,
                    child: const _CustomerDestinationMarker(),
                  ),
                if (deliveryLocation != null)
                  Marker(
                    point: deliveryLocation,
                    width: 50,
                    height: 60,
                    child: const _DeliveryPersonMarker(),
                  ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.small(
            heroTag: 'customer_track_my_loc',
            onPressed: _goToMyLocation,
            backgroundColor: context.colorScheme.primary,
            child: Icon(
              Icons.my_location,
              color: context.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
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
          child: const Icon(Icons.home_outlined, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'موقعك',
            style: TextStyle(color: Colors.white, fontSize: 9),
          ),
        ),
      ],
    );
  }
}

class _DeliveryPersonMarker extends StatelessWidget {
  const _DeliveryPersonMarker();

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
          child: const Icon(
            Icons.delivery_dining,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'المندوب',
            style: TextStyle(color: Colors.white, fontSize: 9),
          ),
        ),
      ],
    );
  }
}
