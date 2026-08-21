
import 'package:car_care/l10n/gen/app_localizations.dart';


final RegExp _brandModelPattern = RegExp(r"^[a-zA-Z؀-ۿ0-9\s\-'&]+$");
final RegExp _plateCharsPattern = RegExp(r'^[a-zA-Z؀-ۿ0-9\s\-]+$');

bool canSubmitVehicleForm({required bool isLoading}) => !isLoading;

const int vehicleImageMaxBytes = 5 * 1024 * 1024;
const Set<String> allowedVehicleImageExtensions = {
  'jpg',
  'jpeg',
  'png',
  'webp',
};

String? validateVehicleBrand(String? value, {required bool isRequired, AppLocalizations? l10n}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return isRequired ? (l10n?.brandRequiredError ?? 'يرجى إدخال الماركة') : null;
  if (v.length < 2) return l10n?.brandMinLengthError ?? 'الماركة يجب أن تكون حرفين على الأقل';
  if (v.length > 50) return l10n?.brandMaxLengthError ?? 'الماركة طويلة جدًا (الحد الأقصى 50 حرفًا)';
  if (!_brandModelPattern.hasMatch(v)) {
    return l10n?.brandInvalidCharsError ?? 'الماركة تحتوي على رموز غير مسموحة';
  }
  return null;
}

String? validateVehicleModel(String? value, {required bool isRequired, AppLocalizations? l10n}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return isRequired ? (l10n?.modelRequiredError ?? 'يرجى إدخال الطراز') : null;
  if (v.length > 50) return l10n?.modelMaxLengthError ?? 'الطراز طويل جدًا (الحد الأقصى 50 حرفًا)';
  if (!_brandModelPattern.hasMatch(v)) {
    return l10n?.modelInvalidCharsError ?? 'الطراز يحتوي على رموز غير مسموحة';
  }
  return null;
}

String? validateVehiclePlateNumber(String? value, {required bool isRequired, AppLocalizations? l10n}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return isRequired ? (l10n?.plateNumberRequiredError ?? 'يرجى إدخال رقم اللوحة') : null;
  if (!_plateCharsPattern.hasMatch(v)) {
    return l10n?.plateInvalidCharsError ?? 'رقم اللوحة يحتوي على رموز غير مسموحة';
  }
  final significant = v.replaceAll(RegExp(r'[\s\-]'), '');
  if (significant.length < 4 || significant.length > 9) {
    return l10n?.plateLengthError ?? 'رقم اللوحة يجب أن يكون بين 4 و 9 محارف';
  }
  return null;
}

String? validateVehicleYear(String? value, {required bool isRequired, AppLocalizations? l10n}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return isRequired ? (l10n?.manufactureYearRequiredError ?? 'يرجى إدخال سنة الصنع') : null;
  final year = int.tryParse(v);
  if (year == null) return l10n?.invalidYearError ?? 'يرجى إدخال سنة صحيحة';
  final maxYear = DateTime.now().year + 1;
  if (year < 1900 || year > maxYear) {
    return l10n?.yearRangeError(maxYear) ?? 'سنة الصنع يجب أن تكون بين 1900 و $maxYear';
  }
  return null;
}

String? validateVehicleCurrentKm(String? value, {required bool isRequired, AppLocalizations? l10n}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return isRequired ? (l10n?.odometerRequiredError ?? 'يرجى إدخال قراءة العداد') : null;
  final km = int.tryParse(v);
  if (km == null) return l10n?.invalidNumberError ?? 'يرجى إدخال رقم صحيح';
  if (km < 0 || km > 2000000) {
    return l10n?.odometerRangeError ?? 'قراءة العداد يجب أن تكون بين 0 و 2000000';
  }
  return null;
}

String? validateVehicleImageFile({required String fileName, int? sizeBytes, AppLocalizations? l10n}) {
  final dotIndex = fileName.lastIndexOf('.');
  final ext = dotIndex == -1
      ? ''
      : fileName.substring(dotIndex + 1).toLowerCase();
  if (!allowedVehicleImageExtensions.contains(ext)) {
    return l10n?.unsupportedImageFormatError ?? 'صيغة الصورة غير مدعومة (jpg، jpeg، png أو webp فقط)';
  }
  if (sizeBytes != null && sizeBytes > vehicleImageMaxBytes) {
    return l10n?.imageSizeExceededError ?? 'حجم الصورة يجب ألا يتجاوز 5 ميجابايت';
  }
  return null;
}

String _normalizeForComparison(String value) =>
    value.trim().replaceAll(RegExp(r'\s+'), ' ');

bool vehicleTextChanged(String current, String initial) =>
    _normalizeForComparison(current) != _normalizeForComparison(initial);

bool vehicleNumberChanged(String current, String initial) {
  final c = int.tryParse(current.trim());
  final i = int.tryParse(initial.trim());
  if (c != null && i != null) return c != i;
  return _normalizeForComparison(current) != _normalizeForComparison(initial);
}

Map<String, String> buildVehicleUpdateFields({
  required String brand,
  required String initialBrand,
  required String model,
  required String initialModel,
  required String year,
  required String initialYear,
  required String plateNumber,
  required String initialPlateNumber,
  required String currentKm,
  required String initialCurrentKm,
}) {
  final fields = <String, String>{};
  if (vehicleTextChanged(brand, initialBrand)) {
    fields['brand'] = brand.trim();
  }
  if (vehicleTextChanged(model, initialModel)) {
    fields['model'] = model.trim();
  }
  if (vehicleNumberChanged(year, initialYear)) {
    fields['year'] = year.trim();
  }
  if (vehicleTextChanged(plateNumber, initialPlateNumber)) {
    fields['plate_number'] = plateNumber.trim();
  }
  if (vehicleNumberChanged(currentKm, initialCurrentKm)) {
    fields['current_km'] = currentKm.trim();
  }
  return fields;
}

bool vehicleEditHasChanges({
  required String brand,
  required String initialBrand,
  required String model,
  required String initialModel,
  required String year,
  required String initialYear,
  required String plateNumber,
  required String initialPlateNumber,
  required String currentKm,
  required String initialCurrentKm,
  required bool hasNewImage,
}) {
  return hasNewImage ||
      buildVehicleUpdateFields(
        brand: brand,
        initialBrand: initialBrand,
        model: model,
        initialModel: initialModel,
        year: year,
        initialYear: initialYear,
        plateNumber: plateNumber,
        initialPlateNumber: initialPlateNumber,
        currentKm: currentKm,
        initialCurrentKm: initialCurrentKm,
      ).isNotEmpty;
}
