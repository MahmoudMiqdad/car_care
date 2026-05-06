import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/car_washer/bookings/presentation/widgets/booking_details_page/action_buttons.dart';
import 'package:car_care/features/car_washer/bookings/presentation/widgets/booking_details_page/details_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingDetailsPage extends StatelessWidget {
  const BookingDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final serviceLines = [
      '${context.l10n.bookingDetailsWasherNameLabel}:  المقداد',
      '${context.l10n.bookingsServiceLabel}:  Vip',
      '${context.l10n.bookingsPriceLabel}:  \$20',
      '${context.l10n.status}:  مقبول ',
    ];

    final appointmentLines = [
      '${context.l10n.bookingsDateTimeLabel}: 4 / 15 ${context.l10n.bookingsAtLabel} 4:00',
      '${context.l10n.bookingDetailsOrderDateLabel}: 4/10',
      '${context.l10n.bookingDetailsVehicleLabel}: هوندا سيتي',
    ];
    
    final userNotesLines = [
      '${context.l10n.notes}: هوندا سيتي sedans.',
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(
          title: context.l10n.bookingDetailsPageTitle,
          showBackButton: true,
        ),
        body: ImageBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/Carfinance-amico.png',
                      height: 150.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  AppText.sectionTitle(
                    context.l10n.bookingDetailsServiceSectionTitle,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  SizedBox(height: 6.h),
                  DetailsCard(
                    lines: serviceLines,
                  ),
                  SizedBox(height: 12.h),
                  AppText.sectionTitle(
                    context.l10n.bookingDetailsAppointmentSectionTitle,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  SizedBox(height: 6.h),
                  DetailsCard(
                    lines: appointmentLines,
                  ),
                  SizedBox(height: 12.h),
                  AppText.sectionTitle(
                    context.l10n.bookingDetailsUserNotesSectionTitle,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  SizedBox(height: 6.h),
                  DetailsCard(
                    lines: userNotesLines,
                  ),
                  SizedBox(height: 25.h),
                  const ActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
