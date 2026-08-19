import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_details_entity.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/cancel_request_cubit/cancel_request_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/cancel_request_cubit/cancel_request_state.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/request_details/cancel_request_dialog.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/request_details/delete_request_dialog.dart';
import 'package:car_care/l10n.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RequestActionButtons extends StatelessWidget {
  const RequestActionButtons({
    super.key,
    required this.data,
    required this.requestId,
  });

  final MaintenanceRequestDetailsDataEntity data;
  final String requestId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; 

    return BlocListener<CancelRequestCubit, CancelRequestState>(
      listener: (context, state) {
        if (state is DeleteRequestSuccess) {
          AppSnackBar.success(context, l10n.requestDeletedSuccess); 
          context.safePopOrGo(Routes.all_requests);
        }
        if (state is DeleteRequestError) {
          AppSnackBar.error(context, state.message);
          context.safePopOrGo(Routes.all_requests);
        }
      },
      child: BlocBuilder<CancelRequestCubit, CancelRequestState>(
        builder: (context, cancelState) {
          final isLoading = cancelState is CancelRequestLoading;

          final hideQuotationsAndDelete =
              data.status == 'in_progress' || data.status == 'completed';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
    
              if (!hideQuotationsAndDelete)
                AppButton(
                  onPressed: () => context.push(
                    Routes.quotations,
                    extra: data.id.toString(),
                  ),
               
                  text: l10n.quotationsCountLabel(data.quotations.length),
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.white,
                  borderRadius: 14.r,
                  height: 52.h,
                ),


              if (data.canCancel) ...[
                SizedBox(height: 12.h),
                AppButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final reason = await showCancelRequestDialog(context);
                          if (reason == null) return;
                          if (!context.mounted) return;
                          context.read<CancelRequestCubit>().cancelRequest(
                                id: requestId,
                                reason: reason,
                              );
                        },
                  text: isLoading ? l10n.cancellingProgress : l10n.cancelRequestButton,
                  backgroundColor: AppColors.reservationConfirmOrange,
                  textColor: AppColors.white,
                  borderRadius: 14.r,
                  height: 52.h,
                ),
              ],

              // زر حذف الطلب
              if (!hideQuotationsAndDelete) ...[
                SizedBox(height: 12.h),
                AppButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final confirmed = await showDeleteRequestDialog(
                            context,
                          );
                          if (confirmed != true) return;
                          if (!context.mounted) return;
                          context.read<CancelRequestCubit>().deleteRequest(
                            id: requestId,
                          );
                        },
                  text: isLoading ? l10n.deletingProgress : l10n.deleteRequestTitle, 
                  backgroundColor: AppColors.red, 
                  textColor: AppColors.white,
                  borderRadius: 14.r,
                  height: 52.h,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
