import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';

/// UI model for a row on the orders list (replace with domain entity when API is wired).
class OrderListItem {
  const OrderListItem({
    required this.id,
    required this.description,
    required this.customerName,
    required this.vehicleInfo,
    required this.date,
    required this.priority,
    required this.imageAssetPath,
  });

  final String id;
  final String description;
  final String customerName;
  final String vehicleInfo;
  final DateTime date;
  final MaintenancePriority priority;
  final String imageAssetPath;
}
