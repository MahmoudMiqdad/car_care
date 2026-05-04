import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/edit_profile_page/edit_profile_washer_labeled_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileWasherServicesSection extends StatelessWidget {
  const EditProfileWasherServicesSection({
    super.key,
    required this.sectionTitle,
    required this.descriptionLabel,
    required this.descriptionHint,
    required this.basicTitle,
    required this.vipTitle,
    required this.premiumTitle,
    required this.priceLabel,
    required this.priceHint,
    this.descriptionController,
    this.basicPriceController,
    this.vipPriceController,
    this.premiumPriceController,
  });

  final String sectionTitle;
  final String descriptionLabel;
  final String descriptionHint;
  final String basicTitle;
  final String vipTitle;
  final String premiumTitle;
  final String priceLabel;
  final String priceHint;
  final TextEditingController? descriptionController;
  final TextEditingController? basicPriceController;
  final TextEditingController? vipPriceController;
  final TextEditingController? premiumPriceController;

  @override
  Widget build(BuildContext context) {
    final priceIcon = Icon(
      Icons.payments_outlined,
      color: AppColors.carWashTeal,
      size: 22.sp,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EditProfileWasherLabeledField(
          label: descriptionLabel,
          hint: descriptionHint,
          controller: descriptionController,
          maxLines: 4,
          minLines: 2,
          leadingIcon: Icon(
            Icons.description_outlined,
            color: AppColors.carWashTeal,
            size: 22.sp,
          ),
        ),
        SizedBox(height: 8.h),
        AppText.sectionTitle(
          priceLabel,
          color: AppColors.black,
          textAlign: TextAlign.right,
          fontSize: 17.sp,
          fontWeight: FontWeight.w800,
        ),
        SizedBox(height: 12.h),
        EditProfileWasherLabeledField(
          label: basicTitle,
          hint: priceHint,
          controller: basicPriceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          leadingIcon: priceIcon,
        ),
        SizedBox(height: 14.h),
        EditProfileWasherLabeledField(
          label: vipTitle,
          hint: priceHint,
          controller: vipPriceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          leadingIcon: priceIcon,
        ),
        SizedBox(height: 14.h),
        EditProfileWasherLabeledField(
          label: premiumTitle,
          hint: priceHint,
          controller: premiumPriceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          leadingIcon: priceIcon,
        ),
      ],
    );
  }
}
