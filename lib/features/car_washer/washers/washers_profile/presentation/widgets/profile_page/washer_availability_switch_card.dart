import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/presentation/cubit/availability_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/presentation/cubit/availability_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherAvailabilitySwitchCard extends StatefulWidget {
  const WasherAvailabilitySwitchCard({super.key, required this.initialValue});

  final bool initialValue;

  @override
  State<WasherAvailabilitySwitchCard> createState() =>
      _WasherAvailabilitySwitchCardState();
}

class _WasherAvailabilitySwitchCardState
    extends State<WasherAvailabilitySwitchCard> {
  late bool _value = widget.initialValue;

  void _onChanged(bool next) {
    if (context.read<AvailabilityCubit>().state is AvailabilityLoading) {
      return; // prevent double submit
    }
    // Deliberately not updated here: no optimistic update. The displayed
    // value only changes once AvailabilitySuccess confirms it below — the
    // Switch is replaced by a small loading indicator in the meantime
    // instead of jumping ahead of the server.
    context.read<AvailabilityCubit>().changeAvailability(next);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AvailabilityCubit, AvailabilityState>(
      listener: (context, state) {
        if (state is AvailabilitySuccess) {
          setState(() => _value = state.isAvailable);
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text('تم تحديث حالة التوفر بنجاح'),
                behavior: SnackBarBehavior.floating,
              ),
            );
        } else if (state is AvailabilityError) {
          // Value was never changed, so it's already back at the previous
          // confirmed state — just surface the error.
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<AvailabilityCubit, AvailabilityState>(
          builder: (context, state) {
            final busy = state is AvailabilityLoading;

            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'متاح لاستقبال الحجوزات',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          _value ? 'متاح حاليًا' : 'غير متاح حاليًا',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: _value ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (busy)
                    SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Switch(
                      value: _value,
                      activeColor: AppColors.carWashTeal,
                      onChanged: _onChanged,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
