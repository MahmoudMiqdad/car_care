import 'package:car_care/features/maintenance/user_quotations/domain/entities/technician_entity.dart';

class QuotationModel {
  final int? id;
  final String? technicianName;
  final double? price;
  final String? status;
  final String? notes;
  final String? createdAt;

  QuotationModel({
    this.id,
    this.technicianName,
    this.price,
    this.status,
    this.notes,
    this.createdAt,
  });

  factory QuotationModel.fromJson(Map<String, dynamic> json) {
    return QuotationModel(
      id: json['id'],
      technicianName: json['technician_name'],
      price: (json['price'] as num?)?.toDouble(),
      status: json['status'],
      notes: json['notes'],
      createdAt: json['created_at'],
    );
  }

  TechnicianEntity? get technician => null;
}