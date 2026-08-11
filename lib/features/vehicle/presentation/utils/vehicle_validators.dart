// Centralized, shared Add/Edit vehicle validators. Pure top-level functions
// so they're directly unit-testable without pumping any widget.
//
// isRequired is false in Edit mode: the field starts pre-filled with the
// current value, so an untouched/empty field must never block submission —
// only a value the user actually typed has to pass the format checks.

/// Letters (Arabic/English), digits, spaces, hyphen, apostrophe and
/// ampersand — covers brand names like "Mercedes-Benz", "Land Rover",
/// "DS 7" and "مرسيدس بنز" while rejecting random symbols
final RegExp _brandModelPattern = RegExp(r"^[a-zA-Z؀-ۿ0-9\s\-'&]+$");

/// Letters (Arabic/English), digits, spaces and hyphen — covers plates like
/// "ABC-123" or a mixed Arabic/English plate.
final RegExp _plateCharsPattern = RegExp(r'^[a-zA-Z؀-ۿ0-9\s\-]+$');

/// True while a request is already in flight — the submit button must be
/// disabled and no second API call issued until it resolves. Shared by
/// Add and Edit vehicle forms.
bool canSubmitVehicleForm({required bool isLoading}) => !isLoading;

const int vehicleImageMaxBytes = 5 * 1024 * 1024;
const Set<String> allowedVehicleImageExtensions = {
  'jpg',
  'jpeg',
  'png',
  'webp',
};

String? validateVehicleBrand(String? value, {required bool isRequired}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return isRequired ? 'يرجى إدخال الماركة' : null;
  if (v.length < 2) return 'الماركة يجب أن تكون حرفين على الأقل';
  if (v.length > 50) return 'الماركة طويلة جدًا (الحد الأقصى 50 حرفًا)';
  if (!_brandModelPattern.hasMatch(v)) {
    return 'الماركة تحتوي على رموز غير مسموحة';
  }
  return null;
}

String? validateVehicleModel(String? value, {required bool isRequired}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return isRequired ? 'يرجى إدخال الطراز' : null;
  if (v.length > 50) return 'الطراز طويل جدًا (الحد الأقصى 50 حرفًا)';
  if (!_brandModelPattern.hasMatch(v)) {
    return 'الطراز يحتوي على رموز غير مسموحة';
  }
  return null;
}

String? validateVehiclePlateNumber(String? value, {required bool isRequired}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return isRequired ? 'يرجى إدخال رقم اللوحة' : null;
  if (!_plateCharsPattern.hasMatch(v)) {
    return 'رقم اللوحة يحتوي على رموز غير مسموحة';
  }
  final significant = v.replaceAll(RegExp(r'[\s\-]'), '');
  if (significant.length < 4 || significant.length > 9) {
    return 'رقم اللوحة يجب أن يكون بين 4 و 9 محارف';
  }
  return null;
}

String? validateVehicleYear(String? value, {required bool isRequired}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return isRequired ? 'يرجى إدخال سنة الصنع' : null;
  final year = int.tryParse(v);
  if (year == null) return 'يرجى إدخال سنة صحيحة';
  final maxYear = DateTime.now().year + 1;
  if (year < 1900 || year > maxYear) {
    return 'سنة الصنع يجب أن تكون بين 1900 و $maxYear';
  }
  return null;
}

String? validateVehicleCurrentKm(String? value, {required bool isRequired}) {
  final v = (value ?? '').trim();
  if (v.isEmpty) return isRequired ? 'يرجى إدخال قراءة العداد' : null;
  final km = int.tryParse(v);
  if (km == null) return 'يرجى إدخال رقم صحيح';
  if (km < 0 || km > 2000000) {
    return 'قراءة العداد يجب أن تكون بين 0 و 2000000';
  }
  return null;
}

/// [fileName] is used only to read the extension; [sizeBytes] is validated
/// only when it could actually be read up front (picker platforms differ).
String? validateVehicleImageFile({required String fileName, int? sizeBytes}) {
  final dotIndex = fileName.lastIndexOf('.');
  final ext = dotIndex == -1
      ? ''
      : fileName.substring(dotIndex + 1).toLowerCase();
  if (!allowedVehicleImageExtensions.contains(ext)) {
    return 'صيغة الصورة غير مدعومة (jpg، jpeg، png أو webp فقط)';
  }
  if (sizeBytes != null && sizeBytes > vehicleImageMaxBytes) {
    return 'حجم الصورة يجب ألا يتجاوز 5 ميجابايت';
  }
  return null;
}

/// Trims and collapses repeated internal whitespace — comparing text fields
/// this way means incidental spacing never reads as "the user changed this".
String _normalizeForComparison(String value) =>
    value.trim().replaceAll(RegExp(r'\s+'), ' ');

bool vehicleTextChanged(String current, String initial) =>
    _normalizeForComparison(current) != _normalizeForComparison(initial);

/// Compares as numbers when both sides parse; falls back to normalized text
/// comparison otherwise (e.g. while the field is empty/invalid mid-edit).
bool vehicleNumberChanged(String current, String initial) {
  final c = int.tryParse(current.trim());
  final i = int.tryParse(initial.trim());
  if (c != null && i != null) return c != i;
  return _normalizeForComparison(current) != _normalizeForComparison(initial);
}

/// Builds the update request body containing *only* the fields that
/// actually changed from their original values. The backend's plate_number
/// uniqueness check runs even on a resubmitted-but-unchanged value, so
/// omitting a field entirely when untouched is required, not cosmetic.
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

/// True when at least one field or the image actually differs from the
/// vehicle's original values — used to skip the API call entirely and show
/// "لم يتم إجراء أي تعديل" instead.
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
