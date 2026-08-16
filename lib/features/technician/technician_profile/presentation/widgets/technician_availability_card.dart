import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_availability_cubit/technician_availability_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_availability_cubit/technician_availability_state.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Compact availability card for the read-only Technician Profile view.
/// Presentation-only restyle of the previous `_AvailabilityToggle` —
/// [TechnicianAvailabilityCubit] wiring (changeAvailability, the
/// getTechnicianProfile() refresh on success) is unchanged.
class TechnicianAvailabilityCard extends StatelessWidget {
  const TechnicianAvailabilityCard({super.key, required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      TechnicianAvailabilityCubit,
      TechnicianAvailabilityState
    >(
      listener: (context, state) {
        if (state is TechnicianAvailabilityError) {
          AppSnackBar.error(context, state.message);
        }
        // بعد نجاح التغيير، حدّث البروفايل عشان يتغير الـ Switch
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
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
                  color: (isAvailable ? AppColors.success : Colors.grey)
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAvailable ? Icons.check_circle : Icons.pause_circle_outline,
                  color: isAvailable ? AppColors.success : Colors.grey.shade500,
                  size: 20.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حالة التوفر',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isAvailable ? 'متاح للعمل' : 'غير متاح للعمل',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: isAvailable
                            ? AppColors.primary
                            : Colors.grey.shade600,
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
                        color: AppColors.orange,
                      ),
                    )
                  : Switch(
                      value: isAvailable,
                      activeThumbColor: AppColors.primary,
                      inactiveThumbColor: Colors.grey.shade400,
                      inactiveTrackColor: Colors.grey.shade200,
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
