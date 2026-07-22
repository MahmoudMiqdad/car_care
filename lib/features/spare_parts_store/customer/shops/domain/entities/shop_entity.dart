// كيان متجر قطع الغيار لعميل متجر قطع الغيار
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_owner_summary_entity.dart';
import 'package:equatable/equatable.dart';

class ShopEntity extends Equatable {
  const ShopEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.isActive,
    required this.owner,
    required this.businessTypes,
    required this.carBrands,
    required this.partCategories,
    required this.createdAt,
    this.status,
    this.rejectionReason,
  });

  final int id;
  final String name;
  final String? phone;
  final String? city;
  final bool isActive;
  final ShopOwnerSummaryEntity? owner;
  final List<String> businessTypes;
  final List<String> carBrands;
  final List<String> partCategories;
  final DateTime? createdAt;
  final String? status;
  final String? rejectionReason;

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    city,
    isActive,
    owner,
    businessTypes,
    carBrands,
    partCategories,
    createdAt,
  ];
}
