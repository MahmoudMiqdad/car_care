
class FuelProviderStatisticsEntity {
  final int totalOrders;
  final int pendingOrders;
  final int acceptedOrders;
  final int inProgressOrders;
  final int completedOrders;
  final int cancelledOrders;
  final double totalRevenue;

  FuelProviderStatisticsEntity({
    required this.totalOrders,
    required this.pendingOrders,
    required this.acceptedOrders,
    required this.inProgressOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.totalRevenue,
  });
}