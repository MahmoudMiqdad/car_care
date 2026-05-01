import 'package:car_care/features/maintenance/user_requests/data/models/quotation_model.dart';

import '../entities/quotation_entity.dart';

extension QuotationMapper on QuotationModel {
  QuotationEntity toEntity() {
    return QuotationEntity(
      id: id ?? 0,
      technicianName: technicianName ?? '',
      price: price ?? 0.0,
      status: status ?? '',
      notes: notes ?? '',
      createdAt: createdAt ?? '',
    );
  }
}