// اختبارات منطق منعزل لدفعة F0E: Parsing سجل الوقود، Partial Update، ألوان
// حالات الوقود/SOS، Mapping صورة المركبة عند مزود الوقود، وبناء AppRouter.
import 'package:car_care/core/routing/app_router.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/data/models/fuel_provider_order_model.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_request_status_badge.dart';
import 'package:car_care/features/vehicle/data/model/fuel_log_model.dart';
import 'package:car_care/features/vehicle/presentation/utils/vehicle_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FuelLogPageModel.fromJson', () {
    test(
      'parses the nested paginator response from the confirmed contract',
      () {
        final page = FuelLogPageModel.fromJson({
          'current_page': 1,
          'data': [
            {
              'id': 1,
              'vehicle_id': 1,
              'fuel_order_id': 1,
              'amount': 20,
              'fuel_type': '95',
              'fuel_provider_id': 1,
              'cost': 150000,
              'km_at_fill': 45000,
              'odometer_image': null,
              'created_at': '2026-08-01T10:00:00.000000Z',
              'updated_at': '2026-08-01T10:00:00.000000Z',
            },
          ],
          'per_page': 15,
          'total': 1,
        });

        expect(page.currentPage, 1);
        expect(page.perPage, 15);
        expect(page.total, 1);
        expect(page.items, hasLength(1));

        final log = page.items.first;
        expect(log.id, 1);
        expect(log.vehicleId, 1);
        expect(log.amount, 20);
        expect(log.fuelType, '95');
        expect(log.cost, 150000);
        expect(log.kmAtFill, 45000);
        expect(log.odometerImage, isNull);
      },
    );

    test('empty pagination (no logs yet) parses to an empty, valid page', () {
      final page = FuelLogPageModel.fromJson({
        'current_page': 1,
        'data': [],
        'per_page': 15,
        'total': 0,
      });

      expect(page.items, isEmpty);
      expect(page.total, 0);
      expect(page.hasMore, isFalse);
    });

    test('numeric fields parse whether the API sends Number or String', () {
      final numeric = FuelLogModel.fromJson({
        'id': 1,
        'amount': 20,
        'cost': 150000,
        'km_at_fill': 45000,
      });
      final stringy = FuelLogModel.fromJson({
        'id': '1',
        'amount': '20',
        'cost': '150000',
        'km_at_fill': '45000',
      });

      expect(numeric.amount, stringy.amount);
      expect(numeric.cost, stringy.cost);
      expect(numeric.kmAtFill, stringy.kmAtFill);
      expect(stringy.amount, 20);
      expect(stringy.cost, 150000);
      expect(stringy.kmAtFill, 45000);
    });

    test('hasMore reflects current_page * per_page vs total', () {
      final notLastPage = FuelLogPageModel.fromJson({
        'current_page': 1,
        'data': List.generate(15, (i) => {'id': i}),
        'per_page': 15,
        'total': 30,
      });
      final lastPage = FuelLogPageModel.fromJson({
        'current_page': 2,
        'data': List.generate(15, (i) => {'id': i}),
        'per_page': 15,
        'total': 30,
      });

      expect(notLastPage.hasMore, isTrue);
      expect(lastPage.hasMore, isFalse);
    });
  });

  group('buildVehicleUpdateFields', () {
    Map<String, String> baseArgs() => {
      'brand': 'BMW',
      'model': 'X5',
      'year': '2020',
      'plateNumber': '1234',
      'currentKm': '1000',
    };

    test('sends only the field that actually changed', () {
      final a = baseArgs();
      final fields = buildVehicleUpdateFields(
        brand: a['brand']!,
        initialBrand: a['brand']!,
        model: a['model']!,
        initialModel: a['model']!,
        year: a['year']!,
        initialYear: a['year']!,
        plateNumber: a['plateNumber']!,
        initialPlateNumber: a['plateNumber']!,
        currentKm: '2000',
        initialCurrentKm: a['currentKm']!,
      );

      expect(fields, {'current_km': '2000'});
    });

    test('plate_number is omitted entirely when left unchanged', () {
      final a = baseArgs();
      final fields = buildVehicleUpdateFields(
        brand: 'Toyota',
        initialBrand: a['brand']!,
        model: a['model']!,
        initialModel: a['model']!,
        year: a['year']!,
        initialYear: a['year']!,
        plateNumber: a['plateNumber']!,
        initialPlateNumber: a['plateNumber']!,
        currentKm: a['currentKm']!,
        initialCurrentKm: a['currentKm']!,
      );

      expect(fields.containsKey('plate_number'), isFalse);
      expect(fields['brand'], 'Toyota');
    });

    test('plate_number is included when it actually changed', () {
      final a = baseArgs();
      final fields = buildVehicleUpdateFields(
        brand: a['brand']!,
        initialBrand: a['brand']!,
        model: a['model']!,
        initialModel: a['model']!,
        year: a['year']!,
        initialYear: a['year']!,
        plateNumber: 'ZZZZ',
        initialPlateNumber: a['plateNumber']!,
        currentKm: a['currentKm']!,
        initialCurrentKm: a['currentKm']!,
      );

      expect(fields['plate_number'], 'ZZZZ');
    });

    test('an empty result means no request should be sent', () {
      final a = baseArgs();
      final fields = buildVehicleUpdateFields(
        brand: a['brand']!,
        initialBrand: a['brand']!,
        model: a['model']!,
        initialModel: a['model']!,
        year: a['year']!,
        initialYear: a['year']!,
        plateNumber: a['plateNumber']!,
        initialPlateNumber: a['plateNumber']!,
        currentKm: a['currentKm']!,
        initialCurrentKm: a['currentKm']!,
      );

      expect(fields, isEmpty);
    });

    test('incidental whitespace differences do not count as a change', () {
      final a = baseArgs();
      final fields = buildVehicleUpdateFields(
        brand: '  BMW  ',
        initialBrand: a['brand']!,
        model: a['model']!,
        initialModel: a['model']!,
        year: a['year']!,
        initialYear: a['year']!,
        plateNumber: a['plateNumber']!,
        initialPlateNumber: a['plateNumber']!,
        currentKm: a['currentKm']!,
        initialCurrentKm: a['currentKm']!,
      );

      expect(fields, isEmpty);
    });
  });

  group(
    'sosRequestStatusBadgeStyleFor (shared by fuel order and SOS cards)',
    () {
      test('completed is green', () {
        expect(
          sosRequestStatusBadgeStyleFor('completed'),
          SosRequestStatusBadgeStyle.softSuccess,
        );
      });

      test('cancelled is red', () {
        expect(
          sosRequestStatusBadgeStyleFor('cancelled'),
          SosRequestStatusBadgeStyle.softError,
        );
      });

      test('pending/accepted/in_progress stay neutral', () {
        for (final status in ['pending', 'accepted', 'in_progress', 'open']) {
          expect(
            sosRequestStatusBadgeStyleFor(status),
            SosRequestStatusBadgeStyle.outlineOnWhite,
            reason: '"$status" must stay neutral',
          );
        }
      });
    },
  );

  group('fuel provider order vehicle image mapping', () {
    test(
      'image and image_path survive Model.fromJson for the provider side',
      () {
        final model = FuelOrderVehicleData.fromJson({
          'id': 1,
          'brand': 'BMW',
          'model': 'X5',
          'image': 'vehicles/photo.jpg',
          'image_path': 'vehicles/legacy.jpg',
        });

        expect(model.image, 'vehicles/photo.jpg');
        expect(model.imagePath, 'vehicles/legacy.jpg');
      },
    );

    test('missing image fields map to null, not a crash', () {
      final model = FuelOrderVehicleData.fromJson({'id': 1, 'brand': 'BMW'});

      expect(model.image, isNull);
      expect(model.imagePath, isNull);
    });
  });

  test('AppRouter.router builds without throwing an Assertion/Exception', () {
    expect(() => AppRouter.router, returnsNormally);
  });
}
