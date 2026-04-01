import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/orders/presentation/models/order_details_ui_model.dart';
import 'package:car_care/features/orders/presentation/widgets/order_details/order_details_customer_section.dart';
import 'package:car_care/features/orders/presentation/widgets/order_details/order_details_malfunction_section.dart';
import 'package:car_care/features/orders/presentation/widgets/order_details/order_details_vehicle_section.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    final model = OrderDetailsUiModel.forOrderId(orderId);
    final h = AppConstants.pageHorizontal;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: const CustomAppBar(
          title: 'Order details',
          showBackButton: true,
        ),
        bottomNavigationBar: HomeBottomNavBar(
          activeIndex: 0,
          onItemSelected: (index) {
            if (index == 0) context.go(Routes.home);
          },
        ),
        body: ImageBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(h, 12.h, h, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrderDetailsVehicleSection(model: model),
                  SizedBox(height: AppConstants.sectionGap),
                  OrderDetailsCustomerSection(model: model),
                  SizedBox(height: AppConstants.sectionGap),
                  OrderDetailsMalfunctionSection(model: model),
                  SizedBox(height: AppConstants.beforeCtaGap),
                  AppButton(
                    text: 'تقديم عرض سعر',
                    backgroundColor: AppColors.accent,
                    fontSize: 17.sp,
                    borderRadius: AppConstants.ctaRadius,
                    height: 55.h, 
                    onPressed: () {
                      debugPrint("تقديم عرض سعر للطلب: $orderId");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}