import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_cubit.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Filter option keys in display order — `null` is "الكل" (sent to the API
/// as no filter at all). Top-level and widget-free so the option set and
/// the `cancelled` spelling are directly unit-testable.
const List<String?> customerBookingFilterStatusKeys = [
  null,
  'pending',
  'accepted',
  'in_progress',
  'completed',
  'cancelled',
];

class CustomerBookingFilter extends StatelessWidget {
  const CustomerBookingFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final Map<String?, String> labelsByKey = {
      null: 'الكل',
      'pending': l10n.bookingStatusPending,
      'accepted': l10n.bookingStatusAccepted,
      'in_progress': l10n.bookingStatusProgress,
      'completed': l10n.bookingStatusCompleted,
      'cancelled': l10n.bookingStatusCanceled,
    };
    final statuses = {
      for (final key in customerBookingFilterStatusKeys) key: labelsByKey[key]!,
    };

    // Selection is read from the cubit (not local widget state) so it
    // always reflects the truth — including after returning from the
    // details page — instead of drifting out of sync with it.
    return BlocBuilder<CustomerBookingsCubit, CustomerBookingsState>(
      buildWhen: (previous, current) => current is CustomerBookingsLoaded,
      builder: (context, state) {
        final selected = state is CustomerBookingsLoaded ? state.status : null;

        return PopupMenuButton<String?>(
          onSelected: (status) => context
              .read<CustomerBookingsCubit>()
              .fetchBookings(status: status),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
            side: BorderSide(color: AppColors.primary, width: 1),
          ),
          elevation: 6,
          color: AppColors.white,
          itemBuilder: (_) {
            return statuses.entries.map((e) {
              final isSelected = e.key == selected;
              return PopupMenuItem<String?>(
                value: e.key,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.value,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.black,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_rounded,
                        size: 18.sp,
                        color: AppColors.primary,
                      ),
                  ],
                ),
              );
            }).toList();
          },
          child: Container(
            height: 52.h,
            decoration: BoxDecoration(
              color: AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primary, width: 1.3),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.black,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    statuses[selected] ?? 'الكل',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
