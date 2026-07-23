// شاشة مشاركة موقع التوصيل للمالك — تغلّف الخريطة بالـ BlocProvider.
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/spare_parts_store/owner/delivery/presentation/cubit/owner_share_location/owner_share_location_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/delivery/presentation/widgets/owner_share_location_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerShareLocationPage extends StatelessWidget {
  const OwnerShareLocationPage({
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (_) => getIt<OwnerShareLocationCubit>(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomAppBar(title: 'مشاركة موقع التوصيل'),
          body: ImageBackground(
            child: OwnerShareLocationMapWidget(
              orderId: orderId,
              customerLat: customerLat,
              customerLng: customerLng,
            ),
          ),
        ),
      ),
    );
  }
}
