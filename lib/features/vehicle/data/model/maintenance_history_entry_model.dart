import 'package:car_care/features/vehicle/domain/entities/maintenance_history_entry_entity.dart';

class MaintenanceHistoryEntryModel extends MaintenanceHistoryEntryEntity {
  const MaintenanceHistoryEntryModel({
    required super.id,
    required super.description,
    required super.part,
    required super.technicianName,
    required super.date,
  });

  factory MaintenanceHistoryEntryModel.fromJson(Map<String, dynamic> json) {
    final completedAtRaw = (json['completed_at'] as String?) ?? '';
    final completedAt = _parseDateTime(completedAtRaw);

    final technician = (json['technician'] as Map<String, dynamic>?) ?? const {};
    final technicianName = (technician['name'] as String?) ?? '';

    final details = (json['details'] as String?) ??
        (json['completion_notes'] as String?) ??
        '';

    final partsText = (json['parts_used_text'] as String?) ?? '';

    return MaintenanceHistoryEntryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      description: details,
      part: partsText,
      technicianName: technicianName,
      date: completedAt,
    );
  }

  static DateTime _parseDateTime(String value) {
    if (value.trim().isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
    final fixed = value.replaceFirst(' ', 'T');
    return DateTime.tryParse(fixed) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }
}