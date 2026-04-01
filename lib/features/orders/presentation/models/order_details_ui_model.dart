import 'package:car_care/core/constants/app_assets.dart';

/// بيانات العرض لصفحة تفاصيل الطلب (يمكن ربطها لاحقاً بالـ API).
class OrderDetailsUiModel {
  const OrderDetailsUiModel({
    required this.vehicleTitle,
    required this.vehicleKmLabel,
    required this.licensePlate,
    required this.vehicleImageAsset,
    required this.customerName,
    required this.customerPhone,
    required this.customerAvatarAsset,
    required this.malfunctionDescription,
    required this.statusLabel,
    required this.preferredDateLabel,
    required this.requestDateLabel,
    required this.priorityBannerLabel,
    required this.issueThumbAssets,
  });

  final String vehicleTitle;
  final String vehicleKmLabel;
  final String licensePlate;
  final String vehicleImageAsset;

  final String customerName;
  final String customerPhone;
  final String customerAvatarAsset;

  final String malfunctionDescription;
  final String statusLabel;
  final String preferredDateLabel;
  final String requestDateLabel;
  final String priorityBannerLabel;
  final List<String> issueThumbAssets;

  /// نموذج يطابق تصميم الشاشة المرجعي.
  static const OrderDetailsUiModel reference = OrderDetailsUiModel(
    vehicleTitle: 'سابا سيدان ٢٠٠٣',
    vehicleKmLabel: '١٢٠,٠٠٠ كم',
    licensePlate: '٣٢٨٧٩٧',
    vehicleImageAsset: AppAssets.serviceMyVehicles,
    customerName: 'محمود المقداد',
    customerPhone: '0982504754',
    customerAvatarAsset: AppAssets.maintenanceIcon,
    malfunctionDescription: 'عطل في الكولاس',
    statusLabel: 'متوقفة تماماً',
    preferredDateLabel: '2026/8/8',
    requestDateLabel: '2026/8/8',
    priorityBannerLabel: 'أولوية صيانة طارئة',
    issueThumbAssets: [
      AppAssets.serviceMaintenance,
      AppAssets.maintenanceIcon,
      AppAssets.serviceSos,
    ],
  );

  static OrderDetailsUiModel forOrderId(String? orderId) {
    if (orderId != null) {
      // لاحقاً: جلب من المستودع حسب orderId
    }
    return reference;
  }
}
