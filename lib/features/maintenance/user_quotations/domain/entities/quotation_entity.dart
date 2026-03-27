import 'package:car_care/features/maintenance/user_quotations/domain/entities/technician_entity.dart';

class QuotationEntity {
  final int id;
  final int price;
  final String priceFormatted;
  final int estimatedDays;
  final String notes;
  final bool partsIncluded;
  final String status;
  final String statusText;
  final TechnicianEntity technician;
  final DateTime createdAt;
  final String createdAgo;

  QuotationEntity({
    required this.id,
    required this.price,
    required this.priceFormatted,
    required this.estimatedDays,
    required this.notes,
    required this.partsIncluded,
    required this.status,
    required this.statusText,
    required this.technician,
    required this.createdAt,
    required this.createdAgo,
  });
}