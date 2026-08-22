import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_status_banner.dart';
import 'package:car_care/features/user_fuel/domain/entities/user_fuel_order_entity.dart';
import 'package:car_care/features/user_fuel/presentation/widgets/fuel_orders_list/fuel_order_card.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpWithApp(WidgetTester tester, Widget child, {String locale = 'ar'}) async {
  tester.view.physicalSize = const Size(1125, 2436);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        locale: Locale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

UserFuelOrderEntity _fakeOrder({
  String? fuelType = '95',
  double? amount = 20.0,
  String? status = 'pending',
  String? statusText = 'قيد الانتظار',
}) {
  return UserFuelOrderEntity(
    id: 1,
    fuelType: fuelType,
    amount: amount,
    deliveryAddress: 'حلب',
    totalPrice: '50',
    status: status,
    statusText: statusText,
    scheduledTime: '2026-01-01 10:00',
  );
}

void main() {
  group('FuelOrderCard — fuel amount uses localized formatting, not raw '
      'concatenation', () {
    testWidgets('Arabic locale renders the localized liters phrase', (
      tester,
    ) async {
      await _pumpWithApp(tester, FuelOrderCard(order: _fakeOrder()));

      expect(find.textContaining('لتر'), findsOneWidget);
      expect(find.text('95 - 20.0 لتر'), findsNothing);
    });

    testWidgets('English locale renders the English liters phrase, not '
        'Arabic', (tester) async {
      await _pumpWithApp(
        tester,
        FuelOrderCard(order: _fakeOrder()),
        locale: 'en',
      );

      expect(find.textContaining('Liters'), findsOneWidget);
      expect(find.textContaining('لتر'), findsNothing);
    });
  });

  group('SosDetailsStatusBanner — status-aware styling (used by fuel order '
      'details)', () {
    testWidgets('a pending status does not use the completed/success '
        'checkmark icon', (tester) async {
      await _pumpWithApp(
        tester,
        const SosDetailsStatusBanner(
          label: 'قيد الانتظار',
          status: 'pending',
        ),
      );

      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
      expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
    });

    testWidgets('a completed status keeps the success checkmark icon', (
      tester,
    ) async {
      await _pumpWithApp(
        tester,
        const SosDetailsStatusBanner(label: 'مكتمل', status: 'completed'),
      );

      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('a cancelled status uses the error icon, not success', (
      tester,
    ) async {
      await _pumpWithApp(
        tester,
        const SosDetailsStatusBanner(label: 'ملغي', status: 'cancelled'),
      );

      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    });

    testWidgets('omitting status keeps the prior always-success behavior '
        'for existing callers (SOS/Maintenance)', (tester) async {
      await _pumpWithApp(
        tester,
        const SosDetailsStatusBanner(label: 'أي حالة'),
      );

      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });
  });
}
