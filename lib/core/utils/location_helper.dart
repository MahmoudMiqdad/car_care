import 'package:geolocator/geolocator.dart';

/// Result of asking the device for its current position.
///
/// Either [position] is set, or [errorMessage] holds a ready-to-show Arabic
/// message explaining why the location could not be read.
class LocationResult {
  const LocationResult._({this.position, this.errorMessage});

  factory LocationResult.success(Position position) =>
      LocationResult._(position: position);

  factory LocationResult.failure(String message) =>
      LocationResult._(errorMessage: message);

  final Position? position;
  final String? errorMessage;

  bool get isSuccess => position != null;
}

/// Checks the location service and permission, then reads the current
/// position with high accuracy.
///
/// Never returns a fallback/fake coordinate — callers must abort when
/// [LocationResult.isSuccess] is false and show [LocationResult.errorMessage].
Future<LocationResult> getCurrentLocation() async {
  try {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult.failure(
        'يرجى تفعيل خدمة الموقع من إعدادات الجهاز',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationResult.failure(
        'صلاحية الموقع مرفوضة نهائيًا، يرجى تفعيلها من إعدادات التطبيق',
      );
    }

    if (permission == LocationPermission.denied) {
      return LocationResult.failure(
        'صلاحية الموقع مطلوبة لإرسال طلب الوقود',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    return LocationResult.success(position);
  } catch (_) {
    return LocationResult.failure(
      'تعذر تحديد موقعك الحالي، حاول مرة أخرى',
    );
  }
}
