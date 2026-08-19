// شاشة تتبع التوصيل للعميل — تغلّف الخريطة بالـ BlocProvider.
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart'; // 🎯 استيراد AppColors للألوان الموحدة
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/presentation/cubit/customer_delivery_tracking/customer_delivery_tracking_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/presentation/widgets/customer_delivery_tracking_map_widget.dart';
import 'package:car_care/l10n.dart'; // 🎯 استيراد امتداد l10n للترجمة الديناميكية
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerDeliveryTrackingPage extends StatelessWidget {
  const CustomerDeliveryTrackingPage({
    super.key,
    required this.orderId,
    this.customerLat,
    this.customerLng,
  });

  final int orderId;
  final double? customerLat;
  final double? customerLng;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; // 🎯 جلب كائن الترجمة داخل الواجهة

    return BlocProvider(
      create: (_) => getIt<CustomerDeliveryTrackingCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.transparent, 
        appBar: CustomAppBar(title: l10n.deliveryTrackingTitle),
        body: ImageBackground(
          child: CustomerDeliveryTrackingMapWidget(
            orderId: orderId,
            customerLat: customerLat,
            customerLng: customerLng,
          ),
        ),
      ),
    );
  }
}
