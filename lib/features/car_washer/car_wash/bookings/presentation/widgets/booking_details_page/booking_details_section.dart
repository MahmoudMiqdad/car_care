
import 'package:car_care/core/widgets/app_headline.dart'; 
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/widgets/booking_details_page/details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingDetailsSection extends StatelessWidget {
  const BookingDetailsSection({
    super.key,
    required this.title,
    required this.lines,
  });

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.sectionTitle(
          context,
          title,
          fontWeight: FontWeight.w800,
        ),
        SizedBox(height: 6.h),
        DetailsCard(lines: lines),
      ],
    );
  }
}
