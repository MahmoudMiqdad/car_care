import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/widgets/provider_order_details/provider_accept_order_dialog.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/widgets/accept_quotation_dialog.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_request_status_badge.dart';
import 'package:car_care/features/technician/technician_quotations/domain/repositories/i_technician_quotations_repository.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/pages/technician_quotations_page.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/sos_requests_list/technician_sos_request_status_badge.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTechnicianQuotationsRepository extends Mock
    implements ITechnicianQuotationsRepository {}

Future<String?> _durationValidationErrorFor(
  WidgetTester tester,
  String? input,
) async {
  tester.view.physicalSize = const Size(1125, 2436);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TechnicianQuotationsPage(requestId: 'r1'),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final field = tester.widget<TextFormField>(find.byType(TextFormField));
  return field.validator!(input);
}

void main() {
  setUp(() {
    getIt.registerLazySingleton<ITechnicianQuotationsRepository>(
      () => MockTechnicianQuotationsRepository(),
    );
  });

  tearDown(() {
    getIt.unregister<ITechnicianQuotationsRepository>();
  });

  group('duration field validation (TechnicianQuotationsPage)', () {
    testWidgets('rejects empty input', (tester) async {
      expect(await _durationValidationErrorFor(tester, ''), isNotNull);
      expect(await _durationValidationErrorFor(tester, null), isNotNull);
    });

    testWidgets('rejects 0 and values above 30', (tester) async {
      expect(await _durationValidationErrorFor(tester, '0'), isNotNull);
      expect(await _durationValidationErrorFor(tester, '31'), isNotNull);
      expect(await _durationValidationErrorFor(tester, '-1'), isNotNull);
    });

    testWidgets('accepts the inclusive 1..30 boundary', (tester) async {
      expect(await _durationValidationErrorFor(tester, '1'), isNull);
      expect(await _durationValidationErrorFor(tester, '30'), isNull);
      expect(await _durationValidationErrorFor(tester, '15'), isNull);
    });

    testWidgets('rejects non-numeric input', (tester) async {
      expect(await _durationValidationErrorFor(tester, 'abc'), isNotNull);
    });
  });

  group('firstSelectableQuotationDate', () {
    test('is exactly tomorrow, independent of current time-of-day', () {
      final now = DateTime.now();
      final expectedTomorrow = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(const Duration(days: 1));

      final result = firstSelectableQuotationDate();

      expect(result.year, expectedTomorrow.year);
      expect(result.month, expectedTomorrow.month);
      expect(result.day, expectedTomorrow.day);
      expect(
        DateTime(
          result.year,
          result.month,
          result.day,
        ).isAfter(DateTime(now.year, now.month, now.day)),
        isTrue,
      );
    });
  });

  group('SOS status color', () {
    test(
      'customer badge: completed=success, cancelled=error, others neutral',
      () {
        expect(
          sosRequestStatusBadgeStyleFor('completed'),
          SosRequestStatusBadgeStyle.softSuccess,
        );
        expect(
          sosRequestStatusBadgeStyleFor('cancelled'),
          SosRequestStatusBadgeStyle.softError,
        );
        for (final status in ['open', 'accepted', 'in_progress']) {
          expect(
            sosRequestStatusBadgeStyleFor(status),
            SosRequestStatusBadgeStyle.outlineOnWhite,
            reason: '"$status" must stay neutral',
          );
        }
      },
    );

    test(
      'technician badge: completed=success, cancelled=error, others neutral',
      () {
        expect(
          technicianSosRequestStatusBadgeStyleFor('completed'),
          TechnicianSosRequestStatusBadgeStyle.softSuccess,
        );
        expect(
          technicianSosRequestStatusBadgeStyleFor('cancelled'),
          TechnicianSosRequestStatusBadgeStyle.softError,
        );
        for (final status in ['open', 'accepted', 'in_progress']) {
          expect(
            technicianSosRequestStatusBadgeStyleFor(status),
            TechnicianSosRequestStatusBadgeStyle.outlineOnWhite,
            reason: '"$status" must stay neutral',
          );
        }
      },
    );
  });

  group('validateProviderEstimatedArrivalMinutes', () {
    test('empty is allowed (field is optional)', () {
      expect(validateProviderEstimatedArrivalMinutes(''), isNull);
      expect(validateProviderEstimatedArrivalMinutes(null), isNull);
    });

    test('accepts the inclusive 1..120 boundary', () {
      expect(validateProviderEstimatedArrivalMinutes('1'), isNull);
      expect(validateProviderEstimatedArrivalMinutes('120'), isNull);
    });

    test('rejects 0 and values above 120', () {
      expect(validateProviderEstimatedArrivalMinutes('0'), isNotNull);
      expect(validateProviderEstimatedArrivalMinutes('121'), isNotNull);
    });

    test('rejects non-numeric input', () {
      expect(validateProviderEstimatedArrivalMinutes('abc'), isNotNull);
    });
  });

  group('validateProviderNotes', () {
    test('accepts exactly 500 characters', () {
      expect(validateProviderNotes('a' * 500), isNull);
    });

    test('rejects more than 500 characters', () {
      expect(validateProviderNotes('a' * 501), isNotNull);
    });
  });
}
