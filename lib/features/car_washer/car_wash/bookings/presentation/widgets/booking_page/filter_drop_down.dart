import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_cubit.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerBookingFilter extends StatefulWidget {
  const CustomerBookingFilter({super.key});

  @override
  State<CustomerBookingFilter> createState() => _CustomerBookingFilterState();
}

class _CustomerBookingFilterState extends State<CustomerBookingFilter> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final Map<String?, String> statuses = {
      null: 'الكل',
      'pending': l10n.bookingStatusPending,
      'accepted': l10n.bookingStatusAccepted,
      'in_progress': l10n.bookingStatusProgress,
      'completed': l10n.bookingStatusCompleted,
      'cancelled': l10n.bookingStatusCanceled,
    };

    return PopupMenuButton<String?>(
      onSelected: (status) {
        setState(() => _selectedStatus = status);
        context.read<CustomerBookingsCubit>().fetchBookings(status: status);
      },
      itemBuilder: (_) {
        return statuses.entries.map((e) {
          return PopupMenuItem<String?>(
            value: e.key,
            child: Text(e.value),
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
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.black),
            SizedBox(width: 8.w),
            Text(
              statuses[_selectedStatus] ?? 'الكل',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}