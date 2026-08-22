class FuelLogEntity {
  final int? id;
  final int? vehicleId;
  final double? amount;
  final String? fuelType;
  final double? cost;
  final int? kmAtFill;
  final String? odometerImage;
  final String? createdAt;

  const FuelLogEntity({
    this.id,
    this.vehicleId,
    this.amount,
    this.fuelType,
    this.cost,
    this.kmAtFill,
    this.odometerImage,
    this.createdAt,
  });
}

class FuelLogPageEntity {
  final int currentPage;
  final List<FuelLogEntity> items;
  final int perPage;
  final int total;

  const FuelLogPageEntity({
    required this.currentPage,
    required this.items,
    required this.perPage,
    required this.total,
  });

  bool get hasMore => currentPage * perPage < total;
}
