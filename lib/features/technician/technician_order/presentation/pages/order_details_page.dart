import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/technician/technician_order/presentation/cubit/request_cubit/request_cubit.dart';
import 'package:car_care/features/technician/technician_order/presentation/cubit/request_cubit/request_state.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_customer_section.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_malfunction_section.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_vehicle_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TechnicianOrderDetailsPage extends StatelessWidget {
  const TechnicianOrderDetailsPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RequestCubit(getIt())..fetchRequest(orderId),
      child: _Body(orderId: orderId),
    );
  }
}

class _Body extends StatelessWidget {
  final String orderId;

  const _Body({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightScaffold,
    appBar: AppBar(title: const Text("طلبات الصيانة")),
      bottomNavigationBar: HomeBottomNavBar(
        activeIndex: -1,
        onItemSelected: (index) {
          if (index == 0) {
            context.go(Routes.home);
          }
        }),
      body: ImageBackground(
        child: BlocBuilder<RequestCubit, RequestState>(
          builder: (context, state) {
            if (state is RequestLoading) {
              return const Center(child: AppLoadingWidget());
            }
        
            if (state is RequestError) {
              return Center(child: Text(state.message));
            }
        
            if (state is RequestLoaded) {
              final data = state.request.data;
        
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderDetailsVehicleSection(model: data.vehicle),
                    SizedBox(height: AppConstants.sectionGap),
                    OrderDetailsCustomerSection(model: data.customer),
                    SizedBox(height: AppConstants.sectionGap),
                    OrderDetailsMalfunctionSection(model: data),
                    SizedBox(height: AppConstants.beforeCtaGap),
                  
        
                   
        
                    SizedBox(height: 10.h),
        
                    AppButton(
                      text: 'تقديم عرض سعر',
                      backgroundColor: AppColors.accent,
                      fontSize: 17.sp,
                      borderRadius: AppConstants.ctaRadius,
                      height: 55.h,
                      onPressed: () {
                        context.push(
                          Routes.technician_quotations,
                          extra: orderId,
                        );
                      },
                    ),
                  ],
                ),
              );
            }
        
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
