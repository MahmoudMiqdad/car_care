import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n.dart';

class BookingDetailsContent extends StatelessWidget {
  const BookingDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.bookingsWasherName,
                style: TextStyle(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              Text(
                '${context.l10n.bookingsServiceLabel}: ${context.l10n.bookingsServiceVip}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              Text(
                '${context.l10n.bookingsDateTimeLabel}: 4 / 15 ${context.l10n.bookingsAtLabel} 4:00',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              Text(
                '${context.l10n.bookingsPriceLabel}: \$20',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 5.w),
        ClipOval(
          child: Image.asset(
            'assets/images/1212s.png',
            height: 88.h,
            width: 88.w,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
