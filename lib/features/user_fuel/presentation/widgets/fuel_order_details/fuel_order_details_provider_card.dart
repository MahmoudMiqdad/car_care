// fuel_order_details_provider_card.dart
import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_section_card.dart';
import 'package:car_care/features/user_fuel/domain/entities/user_fuel_order_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FuelOrderDetailsProviderCard extends StatelessWidget {
  const FuelOrderDetailsProviderCard({super.key, required this.order});

  final UserFuelOrderEntity order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = order.fuelProvider;

    if (provider == null) {
      return SosDetailsSectionCard(
        title: l10n.fuelProvider,
        child: Text(
          l10n.waitingFuelProviderAcceptance,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary(context),
          ),
        ),
      );
    }

    return SosDetailsSectionCard(
      title: l10n.providerOrderDetailsCustomerSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            provider.companyName ?? '-',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.iconPhoneCall,
                width: 20.w,
                height: 20.w,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.phone_in_talk_rounded,
                  size: 15.sp,
                  color: AppColors.carWashTeal,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                provider.phone ?? '-',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProviderOrderDetailsNotesCard extends StatelessWidget {
  const ProviderOrderDetailsNotesCard({
    super.key,
    required this.order,
  });

  final UserFuelOrderEntity order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final notes = order.notes ?? '-';

    return SosDetailsSectionCard(
      title: l10n.orderNotesTitle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AppAssets.NotesIcon, 
            width: 20.w,
            height: 20.w,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.note_alt_outlined,
              size: 18.sp,
              color: AppColors.carWashTeal,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              notes,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
