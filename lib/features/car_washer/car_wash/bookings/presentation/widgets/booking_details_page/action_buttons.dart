import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_cubit.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ActionButtons extends StatefulWidget {
  const ActionButtons({super.key, required this.booking});

  final BookingsEntity booking;

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _showCancelDialog(BuildContext context) {
    final string = context.l10n;
    _reasonController.clear();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(string.bookingsMenuCancelBooking),
        content: TextField(
          controller: _reasonController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: string.cancellationReason,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(string.back),
          ),
          TextButton(
            onPressed: () {
              final reason = _reasonController.text.trim();
              if (reason.isEmpty) return;
              Navigator.pop(dialogContext);
              context.read<CustomerBookingsCubit>().cancelBooking(
                widget.booking.id,
                reason,
              );
            },
            child: Text(
              string.confirm,
              style: TextStyle(color: context.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final string = context.l10n;
    final booking = widget.booking;
    final canCancel = booking.status == 'pending' && booking.canCancel;
    final canRate = booking.status == 'completed';

    return Row(
      children: [
        if (canRate)
          Expanded(
            child: AppButton(
              onPressed: () async {
                final result = await context.push(
                  Routes.ratings,
                  extra: booking,
                );
                if (result == true && context.mounted) {
                  context.safePopOrGo(Routes.bookings, result: true);
                }
              },
              text: string.bookingsMenuRateService,
              textColor: AppColors.white,
              borderRadius: 12.r,
              fontSize: 18.sp,
              height: 46.h,
            ),
          ),
        if (canCancel) ...[
          if (canRate) SizedBox(width: 14.w),
          Expanded(
            child: AppButton(
              onPressed: () => _showCancelDialog(context),
              text: string.bookingsMenuCancelBooking,
              isOutline: true,
              backgroundColor: AppColors.primary,
              outlineSurfaceColor: AppColors.white,
              borderRadius: 12.r,
              fontSize: 18.sp,
              height: 46.h,
            ),
          ),
        ],
      ],
    );
  }
}
