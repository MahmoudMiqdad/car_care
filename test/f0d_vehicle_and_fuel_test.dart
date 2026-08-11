// اختبارات منطق منعزل لدفعة F0D: Validators المركبة، اكتشاف عدم وجود
// تغييرات، منع Submit أثناء Loading، وMapping صورة المركبة في طلب الوقود.
import 'package:car_care/core/utils/media_url.dart';
import 'package:car_care/features/user_fuel/data/model/user_fuel_order_model.dart';
import 'package:car_care/features/vehicle/presentation/utils/vehicle_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateVehicleBrand', () {
    test('required in Add: empty is rejected', () {
      expect(validateVehicleBrand('', isRequired: true), isNotNull);
      expect(validateVehicleBrand(null, isRequired: true), isNotNull);
    });

    test('optional in Edit: empty is allowed', () {
      expect(validateVehicleBrand('', isRequired: false), isNull);
    });

    test('accepts real-world brand names', () {
      for (final brand in [
        'BMW',
        'MG',
        'Mercedes-Benz',
        'Land Rover',
        'DS 7',
        'مرسيدس بنز',
      ]) {
        expect(
          validateVehicleBrand(brand, isRequired: true),
          isNull,
          reason: '"$brand" should be a valid brand',
        );
      }
    });

    test('rejects too short, too long and random symbols', () {
      expect(validateVehicleBrand('B', isRequired: true), isNotNull);
      expect(validateVehicleBrand('B' * 51, isRequired: true), isNotNull);
      expect(validateVehicleBrand('BM/W*!', isRequired: true), isNotNull);
    });
  });

  group('validateVehicleModel', () {
    test('accepts real-world model names', () {
      for (final model in ['3', 'A4', 'CX-5', 'C-HR', 'F-150']) {
        expect(
          validateVehicleModel(model, isRequired: true),
          isNull,
          reason: '"$model" should be a valid model',
        );
      }
    });

    test('optional in Edit, required in Add', () {
      expect(validateVehicleModel('', isRequired: false), isNull);
      expect(validateVehicleModel('', isRequired: true), isNotNull);
    });
  });

  group('validateVehiclePlateNumber', () {
    test('length is computed after removing spaces and hyphens', () {
      expect(validateVehiclePlateNumber('AB-12', isRequired: true), isNull);
      expect(validateVehiclePlateNumber('12', isRequired: true), isNotNull);
    });

    test('accepts the inclusive 4..9 significant-character boundary', () {
      expect(validateVehiclePlateNumber('1234', isRequired: true), isNull);
      expect(validateVehiclePlateNumber('123456789', isRequired: true), isNull);
    });

    test('rejects below 4 and above 9 significant characters', () {
      expect(validateVehiclePlateNumber('123', isRequired: true), isNotNull);
      expect(
        validateVehiclePlateNumber('1234567890', isRequired: true),
        isNotNull,
      );
    });

    test('optional in Edit when left unchanged/empty', () {
      expect(validateVehiclePlateNumber('', isRequired: false), isNull);
    });
  });

  group('validateVehicleYear', () {
    test('accepts the dynamic 1900..currentYear+1 boundary', () {
      final maxYear = DateTime.now().year + 1;
      expect(validateVehicleYear('1900', isRequired: true), isNull);
      expect(validateVehicleYear(maxYear.toString(), isRequired: true), isNull);
    });

    test('rejects out-of-range years', () {
      expect(validateVehicleYear('1899', isRequired: true), isNotNull);
      final tooFar = (DateTime.now().year + 2).toString();
      expect(validateVehicleYear(tooFar, isRequired: true), isNotNull);
    });
  });

  group('validateVehicleCurrentKm', () {
    test('accepts the inclusive 0..2000000 boundary', () {
      expect(validateVehicleCurrentKm('0', isRequired: true), isNull);
      expect(validateVehicleCurrentKm('2000000', isRequired: true), isNull);
    });

    test('rejects negative and above-max values', () {
      expect(validateVehicleCurrentKm('-1', isRequired: true), isNotNull);
      expect(validateVehicleCurrentKm('2000001', isRequired: true), isNotNull);
    });
  });

  group('validateVehicleImageFile', () {
    test('accepts allowed extensions', () {
      for (final ext in ['jpg', 'jpeg', 'png', 'webp']) {
        expect(
          validateVehicleImageFile(fileName: 'car.$ext'),
          isNull,
          reason: '.$ext should be allowed',
        );
      }
    });

    test('rejects unsupported extensions', () {
      expect(validateVehicleImageFile(fileName: 'car.gif'), isNotNull);
    });

    test('rejects files over the 5MB limit when size is known', () {
      expect(
        validateVehicleImageFile(
          fileName: 'car.jpg',
          sizeBytes: vehicleImageMaxBytes + 1,
        ),
        isNotNull,
      );
      expect(
        validateVehicleImageFile(
          fileName: 'car.jpg',
          sizeBytes: vehicleImageMaxBytes,
        ),
        isNull,
      );
    });
  });

  group('vehicleEditHasChanges', () {
    Map<String, String> baseArgs() => {
      'brand': 'BMW',
      'model': 'X5',
      'year': '2020',
      'plateNumber': '1234',
      'currentKm': '1000',
    };

    test('false when nothing changed and no new image', () {
      final a = baseArgs();
      expect(
        vehicleEditHasChanges(
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
          hasNewImage: false,
        ),
        isFalse,
      );
    });

    test('true when a single field changed', () {
      final a = baseArgs();
      expect(
        vehicleEditHasChanges(
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
          hasNewImage: false,
        ),
        isTrue,
      );
    });

    test('true when only a new image was picked', () {
      final a = baseArgs();
      expect(
        vehicleEditHasChanges(
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
          hasNewImage: true,
        ),
        isTrue,
      );
    });
  });

  group('canSubmitVehicleForm', () {
    test('blocks submission while loading', () {
      expect(canSubmitVehicleForm(isLoading: true), isFalse);
      expect(canSubmitVehicleForm(isLoading: false), isTrue);
    });
  });

  group('fuel order vehicle image mapping', () {
    test('image and image_path survive Model.fromJson', () {
      final model = UserFuelOrderVehicleData.fromJson({
        'id': 1,
        'brand': 'BMW',
        'model': 'X5',
        'image': 'vehicles/photo.jpg',
        'image_path': 'vehicles/legacy.jpg',
      });

      expect(model.image, 'vehicles/photo.jpg');
      expect(model.imagePath, 'vehicles/legacy.jpg');
    });

    test('missing image fields map to null, not a crash', () {
      final model = UserFuelOrderVehicleData.fromJson({
        'id': 1,
        'brand': 'BMW',
        'model': 'X5',
      });

      expect(model.image, isNull);
      expect(model.imagePath, isNull);
    });
  });

  group('resolveMediaUrl fallback (used by the fuel order vehicle avatar)', () {
    test('null/empty resolves to null so the UI shows the placeholder', () {
      expect(resolveMediaUrl(null), isNull);
      expect(resolveMediaUrl(''), isNull);
      expect(resolveMediaUrl('   '), isNull);
    });

    test('already-absolute URLs are returned unchanged', () {
      expect(
        resolveMediaUrl('https://example.com/x.jpg'),
        'https://example.com/x.jpg',
      );
    });
  });
}
