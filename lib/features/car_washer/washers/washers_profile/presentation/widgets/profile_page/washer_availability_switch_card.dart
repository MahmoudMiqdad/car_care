import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/presentation/cubit/availability_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/presentation/cubit/availability_state.dart';
import 'package:car_care/l10n.dart';
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
      return;
    }
    context.read<AvailabilityCubit>().changeAvailability(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<AvailabilityCubit, AvailabilityState>(
      listener: (context, state) {
        if (state is AvailabilitySuccess) {
          setState(() => _value = state.isAvailable);
          AppSnackBar.success(context, l10n.washerAvailabilityUpdateSuccess);
        } else if (state is AvailabilityError) {
          AppSnackBar.error(context, state.message);
        }
      },
      child: BlocBuilder<AvailabilityCubit, AvailabilityState>(
        builder: (context, state) {
          final busy = state is AvailabilityLoading;

          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainer.withValues(
                alpha: 0.9,
              ),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.border(context)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.washerAvailabilityTitle,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _value
                            ? l10n.washerAvailabilityStatusAvailable
                            : l10n.washerAvailabilityStatusUnavailable,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: _value
                              ? AppColors.successColor(context)
                              : context.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                if (busy)
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.carWashTeal,
                      ),
                    ),
                  )
                else
                  Switch(
                    value: _value,
                    activeColor: AppColors.carWashTeal,
                    inactiveTrackColor: AppColors.border(
                      context,
                    ).withValues(alpha: 0.5),
                    onChanged: _onChanged,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
