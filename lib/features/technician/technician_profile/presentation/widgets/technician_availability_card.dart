import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_availability_cubit/technician_availability_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_availability_cubit/technician_availability_state.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_cubit.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TechnicianAvailabilityCard extends StatelessWidget {
  const TechnicianAvailabilityCard({super.key, required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<
      TechnicianAvailabilityCubit,
      TechnicianAvailabilityState
    >(
      listener: (context, state) {
        if (state is TechnicianAvailabilityError) {
          AppSnackBar.error(context, state.message);
        }

        if (state is TechnicianAvailabilitySuccess) {
          context.read<TechnicianProfileCubit>().getTechnicianProfile();
        }
      },
      builder: (context, availState) {
        final isLoading = availState is TechnicianAvailabilityLoading;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 10.r,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: (isAvailable ? AppColors.green : AppColors.border(context))
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAvailable ? Icons.check_circle : Icons.pause_circle_outline,
                  color: isAvailable ? AppColors.green : AppColors.textSecondary(context),
                  size: 20.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.availabilityStatusLabel,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isAvailable ? l10n.availableForWork : l10n.unavailableForWork,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: isAvailable
                            ? AppColors.primary
                            : AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.accent,
                      ),
                    )
                  : Switch(
                      value: isAvailable,
                      activeThumbColor: AppColors.primary,
                      inactiveThumbColor: AppColors.border(context),
                      inactiveTrackColor: AppColors.secondary,
                      onChanged: (val) {
                        context
                            .read<TechnicianAvailabilityCubit>()
                            .changeAvailability(val ? '1' : '0');
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}
