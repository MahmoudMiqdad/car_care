class FuelProviderStatisticsModel {
  final bool? success;
  final FuelProviderStatisticsData? data;

  FuelProviderStatisticsModel({this.success, this.data});

  factory FuelProviderStatisticsModel.fromJson(Map<String, dynamic> json) =>
      FuelProviderStatisticsModel(
        success: json['success'],
        data: json['data'] != null
            ? FuelProviderStatisticsData.fromJson(json['data'])
            : null,
      );
}
class FuelProviderStatisticsData {
  final int? totalOrders;
  final int? pendingOrders;
  final int? acceptedOrders;
  final int? inProgressOrders;
  final int? completedOrders;
  final int? cancelledOrders;
  final double? totalRevenue;

  FuelProviderStatisticsData({
    this.totalOrders,
    this.pendingOrders,
    this.acceptedOrders,
    this.inProgressOrders,
    this.completedOrders,
    this.cancelledOrders,
    this.totalRevenue,
  });

  factory FuelProviderStatisticsData.fromJson(Map<String, dynamic> json) =>
      FuelProviderStatisticsData(
        totalOrders: json['total_orders'],
        pendingOrders: json['pending_orders'],
        acceptedOrders: json['accepted_orders'],
        inProgressOrders: json['in_progress_orders'],
        completedOrders: json['completed_orders'],
        cancelledOrders: json['cancelled_orders'],
        totalRevenue: double.tryParse(json['total_revenue'].toString()),
      );
}