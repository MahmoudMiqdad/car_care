import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingDetailsContent extends StatelessWidget {
  const BookingDetailsContent({
    super.key,
    required this.booking,
    required this.onShowDetails,
  });

  final BookingsEntity booking;
  final VoidCallback onShowDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final washerName = booking.carWasher?.shopName ?? l10n.bookingsWasherName;
    final washerLogoUrl = booking.carWasher?.logoUrl;
    final priceText = booking.price ?? '0';
    final onSurface = context.colorScheme.onSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                washerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w700,
                  color: onSurface,
                ),
              ),
              Text(
                '${l10n.bookingsServiceLabel}: ${booking.serviceType}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: onSurface,
                ),
              ),
              Text(
                '${l10n.bookingsDateTimeLabel}: ${booking.scheduledAt}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: onSurface,
                ),
              ),
              Text(
                '${l10n.bookingsPriceLabel}: \$$priceText',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: onSurface,
                ),
              ),
              SizedBox(height: 6.h),
              SizedBox(
                width: 130,
                height: 36.h,
                child: AppButton(
                  onPressed: onShowDetails,
                  text: l10n.bookingsMenuShowDetails,
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 5.w),

        ClipOval(
          child: SizedBox(
            height: 88.h,
            width: 88.w,
            child: (washerLogoUrl != null && washerLogoUrl.isNotEmpty)
                ? Image.network(
                    washerLogoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Image.asset(
                      'assets/images/1212s.png',
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset('assets/images/1212s.png', fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
