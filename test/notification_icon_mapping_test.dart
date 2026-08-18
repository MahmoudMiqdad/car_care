// اختبارات mapping الأيقونة/اللون حسب notification.type: كل نوع معروف له
// أيقونة مختلفة، والألوان تبقى محصورة بهوية المشروع (primary/accent فقط).
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/notifications/presentation/widgets/notification_icon_mapping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationIconMapping.iconFor', () {
    test('known types map to their expected icon', () {
      expect(
        NotificationIconMapping.iconFor('fuel_order_accepted'),
        Icons.local_gas_station_rounded,
      );
      expect(NotificationIconMapping.iconFor('sos_accepted'), Icons.sos);
      expect(
        NotificationIconMapping.iconFor('carwash_booking_confirmed'),
        Icons.local_car_wash_rounded,
      );
      expect(
        NotificationIconMapping.iconFor('maintenance_completed'),
        Icons.build_rounded,
      );
      expect(
        NotificationIconMapping.iconFor('spare_parts_order_shipped'),
        Icons.settings_rounded,
      );
      expect(
        NotificationIconMapping.iconFor('provider_registered'),
        Icons.storefront_rounded,
      );
      expect(
        NotificationIconMapping.iconFor('invoice_issued'),
        Icons.receipt_long_rounded,
      );
    });

    test('an unknown type falls back to the generic bell icon', () {
      expect(
        NotificationIconMapping.iconFor('something_new_and_unmapped'),
        Icons.notifications_rounded,
      );
    });
  });

  group('NotificationIconMapping.colorFor — identity colors only', () {
    test('sos types use the accent color', () {
      expect(NotificationIconMapping.colorFor('sos_created'), AppColors.accent);
    });

    test('every other type uses the primary color', () {
      expect(
        NotificationIconMapping.colorFor('fuel_order_accepted'),
        AppColors.primary,
      );
      expect(
        NotificationIconMapping.colorFor('unknown_type'),
        AppColors.primary,
      );
    });
  });
}
