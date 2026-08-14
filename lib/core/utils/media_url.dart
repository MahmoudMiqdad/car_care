import 'package:car_care/core/config/env.dart';

/// Resolves a backend image field to a full URL.
///
/// - `null` / empty -> null (callers show a placeholder)
/// - already absolute (`http...`) -> returned as-is
/// - relative (`vehicles/x.jpg`) -> `{origin}/storage/vehicles/x.jpg`
///
/// The origin is derived from [Env.baseUrl] so it follows the configured
/// environment instead of a hardcoded host.
String? resolveMediaUrl(String? raw) {
  final value = raw?.trim();
  if (value == null || value.isEmpty) return null;
  if (value.startsWith('http')) return value;

  final base = Uri.parse(Env.baseUrl);
  final origin = '${base.scheme}://${base.authority}';
  final normalized = value.startsWith('/') ? value.substring(1) : value;
  return '$origin/storage/$normalized';
}

/// Builds "Brand Model Year" without repeating identical parts, so a vehicle
/// whose model and year are both "2025" renders as "Cadillac 2025".
String buildVehicleLabel({
  String? brand,
  String? model,
  String? year,
}) {
  final parts = <String>[];
  for (final part in [brand, model, year]) {
    final value = part?.trim();
    if (value == null || value.isEmpty) continue;
    if (parts.contains(value)) continue;
    parts.add(value);
  }
  return parts.isEmpty ? '-' : parts.join(' ');
}
