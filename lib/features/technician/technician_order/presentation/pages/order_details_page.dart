import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/technician/technician_order/presentation/cubit/request_cubit/request_cubit.dart';
import 'package:car_care/features/technician/technician_order/presentation/cubit/request_cubit/request_state.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_customer_section.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_malfunction_section.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_vehicle_section.dart';
import 'package:car_care/l10n.dart';
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

class _Body extends StatefulWidget {
  final String orderId;

  const _Body({required this.orderId});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  String get orderId => widget.orderId;
  bool _justSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBar(title: Text(l10n.maintenanceRequestDetailsTitle)),
      body: ImageBackground(
        child: SafeArea(
          top: false,
          child: BlocBuilder<RequestCubit, RequestState>(
            builder: (context, state) {
              if (state is RequestLoading) {
                return const Center(child: AppLoadingWidget());
              }

              if (state is RequestError) {
                return Center(
                  child: Text(localizeErrorMessage(context, state.message)),
                );
              }

              if (state is RequestLoaded) {
                final data = state.request.data;
                final hasQuotation = data.myQuotation != null || _justSubmitted;

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

                      if (hasQuotation)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.serviceTierSelectedBackground,
                            borderRadius: BorderRadius.circular(
                              AppConstants.ctaRadius,
                            ),
                            border: Border.all(color: AppColors.green),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: AppColors.green,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  l10n.quotationSentWaitingApproval,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        AppButton(
                          text: l10n.submitQuotationButtonLabel,
                          fontSize: 17.sp,
                          borderRadius: AppConstants.ctaRadius,
                          height: 55.h,
                          onPressed: () async {
                            final submitted = await context.push<bool>(
                              Routes.technician_quotations,
                              extra: orderId,
                            );
                            if (!context.mounted) return;
                            if (submitted == true) {
                              setState(() => _justSubmitted = true);
                              AppSnackBar.success(
                                context,
                                l10n.quotationSubmittedSuccess,
                              );
                            }
                            context.read<RequestCubit>().fetchRequest(orderId);
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
      ),
    );
  }
}
