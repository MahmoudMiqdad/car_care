import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/edit_profile_page/edit_profile_washer_labeled_field.dart';
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
        SizedBox(height: 14.h),
        AppText.sectionTitle(
          context,
          priceLabel,
          color: context.colorScheme.onSurface,
          textAlign: TextAlign.start,
          fontWeight: FontWeight.w800,
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _PriceTierField(
                label: basicTitle,
                hint: priceHint,
                controller: basicPriceController,
                accentColor: AppColors.carWashTeal,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _PriceTierField(
                label: vipTitle,
                hint: priceHint,
                controller: vipPriceController,
                accentColor: AppColors.accent,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _PriceTierField(
                label: premiumTitle,
                hint: priceHint,
                controller: premiumPriceController,
                accentColor: AppColors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PriceTierField extends StatelessWidget {
  const _PriceTierField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.accentColor,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.w700,
            color: accentColor,
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: context.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary(context).withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: context.colorScheme.surfaceContainer,
            prefixIcon: Icon(
              Icons.payments_outlined,
              size: 14.sp,
              color: accentColor,
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 26.w),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 6.w,
              vertical: 10.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: accentColor.withValues(alpha: 0.4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: accentColor.withValues(alpha: 0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: accentColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
