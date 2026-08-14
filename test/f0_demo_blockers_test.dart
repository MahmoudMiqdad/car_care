// اختبارات منطق منعزل لدفعتي F0 وF0B: التحقق من المدة المقدرة، تاريخ القبول،
// لون حالة SOS، وتحقق قبول طلب الوقود (المدة والملاحظات).
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/widgets/provider_order_details/provider_accept_order_dialog.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/widgets/accept_quotation_dialog.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_request_status_badge.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/pages/technician_quotations_page.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/sos_requests_list/technician_sos_request_status_badge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateEstimatedDays', () {
    test('rejects empty input', () {
      expect(validateEstimatedDays(''), isNotNull);
      expect(validateEstimatedDays(null), isNotNull);
    });

    test('rejects 0 and values above 30', () {
      expect(validateEstimatedDays('0'), isNotNull);
      expect(validateEstimatedDays('31'), isNotNull);
      expect(validateEstimatedDays('-1'), isNotNull);
    });

    test('accepts the inclusive 1..30 boundary', () {
      expect(validateEstimatedDays('1'), isNull);
      expect(validateEstimatedDays('30'), isNull);
      expect(validateEstimatedDays('15'), isNull);
    });

    test('rejects non-numeric input', () {
      expect(validateEstimatedDays('abc'), isNotNull);
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
      // Never today.
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
