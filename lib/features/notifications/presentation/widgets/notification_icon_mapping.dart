import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Maps a backend `notification.type` to a display icon. Colors are always
/// drawn from [AppColors] — SOS/emergency types use the accent color, every
/// other known type uses primary, and unknown types fall back to a generic
/// bell in primary.
class NotificationIconMapping {
  const NotificationIconMapping._();

  static IconData iconFor(String type) {
    if (type.startsWith('fuel_order')) return Icons.local_gas_station_rounded;
    if (type.startsWith('sos')) return Icons.sos;
    if (type.startsWith('carwash_booking')) return Icons.local_car_wash_rounded;
    if (type.startsWith('maintenance')) return Icons.build_rounded;
    if (type.startsWith('spare_parts_order')) return Icons.settings_rounded;
    if (type.startsWith('provider')) return Icons.storefront_rounded;
    if (type.startsWith('invoice')) return Icons.receipt_long_rounded;
    return Icons.notifications_rounded;
  }

  static Color colorFor(String type) {
    if (type.startsWith('sos')) return AppColors.accent;
    return AppColors.primary;
  }
}
