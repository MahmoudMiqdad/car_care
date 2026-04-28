import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/car_washer/bookings/presentation/widgets/booking_card.dart';
import 'package:car_care/features/car_washer/bookings/presentation/widgets/filter_drop_down.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statusChips = [
      context.l10n.bookingStatusProgress,
      context.l10n.bookingStatusAccepted,
      context.l10n.bookingStatusPinding,
    ];
    final bookings = [false, true];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          title: context.l10n.bookingsPageTitle,
          showBackButton: true,
          onBackTapped: () => context.pop(),
        ),
        backgroundColor: AppColors.lightScaffold,
        body: ImageBackground(
          child: SafeArea(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 20.h),
              itemCount: bookings.length + 1,
              separatorBuilder: (_, index) {
                if (index == 0) {
                  return SizedBox(height: 24.h);
                }
                return SizedBox(height: 12.h);
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      SizedBox(height: 24.h),
                      const FilterDropdown(),
                    ],
                  );
                }
                final bookingIndex = index - 1;
                return BookingCard(
                  statusChips: statusChips,
                  showMenuByDefault: bookings[bookingIndex],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
