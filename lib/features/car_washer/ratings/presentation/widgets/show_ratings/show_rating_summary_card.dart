import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowRatingSummaryCard extends StatelessWidget {
  const ShowRatingSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.sectionTitle(
          strings.showRatingTotalBookings,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: .86),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: SummaryColumn(
                    items: [
                      SummaryItem(strings.showRatingAllReserved, '240'),
                      SummaryItem(strings.pending, '40'),
                      SummaryItem(strings.bookingStatusAccepted, '60'),
                    ],
                  ),
                ),
                VerticalDivider(
                  width: 24.w,
                  thickness: 1,
                  color: AppColors.lightTextSecondary,
                ),
                Expanded(
                  child: SummaryColumn(
                    items: [
                      SummaryItem(strings.showRatingInProgress, '20'),
                      SummaryItem(strings.completed, '80'),
                      SummaryItem(strings.cancelled, '40'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SummaryColumn extends StatelessWidget {
  const SummaryColumn({super.key, required this.items});

  final List<SummaryItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: RichText(
                textDirection: TextDirection.ltr,
                text: TextSpan(
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  children: [
                    TextSpan(text: '${item.label} : '),
                    TextSpan(
                      text: item.value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class SummaryItem {
  const SummaryItem(this.label, this.value);

  final String label;
  final String value;
}
