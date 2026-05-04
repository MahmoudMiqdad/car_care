import 'package:car_care/core/constants/app_text_styles.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileWasherContactCardsRow extends StatelessWidget {
  const ProfileWasherContactCardsRow({
    super.key,
    required this.phone,
    required this.workStart,
    required this.workEnd,
  });

  final String phone;
  final String workStart;
  final String workEnd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final phoneCard = Expanded(
      child: _ProfileWasherTealBorderCard(
        child: _ContactCardInnerRow(
          icon: Icons.phone_in_talk_rounded,
          body: Text(
            phone,
            textDirection: TextDirection.ltr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font15LightTextPrimarySemiBold,
          ),
        ),
      ),
    );

    final hoursCard = Expanded(
      child: _ProfileWasherTealBorderCard(
        child: _ContactCardInnerRow(
          icon: Icons.hourglass_empty_rounded,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.washerOpenTime(workStart),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font13LightTextPrimarySemiBold,
              ),
              Text(
                l10n.washerCloseTime(workEnd),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font13LightTextPrimarySemiBold,
              ),
            ],
          ),
        ),
      ),
    );

    final gap = SizedBox(width: 12.w);

    return Row(
      children: isRtl ? [phoneCard, gap, hoursCard] : [hoursCard, gap, phoneCard],
    );
  }
}

class _ContactCardInnerRow extends StatelessWidget {
  const _ContactCardInnerRow({
    required this.icon,
    required this.body,
  });

  final IconData icon;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.carWashTeal,
          size: 30.sp,
        ),
        SizedBox(width: 8.w),
        Expanded(child: body),
      ],
    );
  }
}

class _ProfileWasherTealBorderCard extends StatelessWidget {
  const _ProfileWasherTealBorderCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.carWashTeal, width: 1.2),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: child,
      ),
    );
  }
}
