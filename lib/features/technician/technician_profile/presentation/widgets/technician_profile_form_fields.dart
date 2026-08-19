import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_profile_labeled_field.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_profile_section.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class TechnicianProfileFormFields extends StatelessWidget {
  const TechnicianProfileFormFields({
    super.key,
    required this.phoneController,
    required this.cityController,
    required this.specializationController,
    required this.experienceController,
    required this.hourlyRateController,
  });

  final TextEditingController phoneController;
  final TextEditingController cityController;
  final TextEditingController specializationController;
  final TextEditingController experienceController;
  final TextEditingController hourlyRateController;

  static const List<MapEntry<String, String>> _experienceSuggestions = [
    MapEntry('1', '1'),
    MapEntry('3', '3'),
    MapEntry('5', '5'),
    MapEntry('+10', '10'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final List<String> specializationSuggestions = [
      l10n.mechanicLabel,
      l10n.electricityLabel,
      l10n.paintLabel,
      l10n.tiresLabel,
      l10n.airConditioningLabel,
      l10n.plumbingLabel,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TechnicianProfileSection(
          title: l10n.personalDataTitle,
          icon: Icons.person_outline,
          color: AppColors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TechnicianProfileLabeledField(
                label: l10n.phoneNumberLabel,
                controller: phoneController,
                icon: IconsaxPlusLinear.call,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12.h),
              TechnicianProfileLabeledField(
                label: l10n.cityLabel,
                controller: cityController,
                iconPath: 'assets/images/icons8-location-50.png',
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        TechnicianProfileSection(
          title: l10n.professionalDataTitle,
          icon: Icons.engineering_outlined,
          color: AppColors.accent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TechnicianProfileLabeledField(
                label: l10n.specializationLabel,
                controller: specializationController,
                iconPath: 'assets/images/icons8-work-50.png',
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: specializationSuggestions
                    .map(
                      (option) => _QuickFillChip(
                        label: option,
                        onTap: () => specializationController.text = option,
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 14.h),
              TechnicianProfileLabeledField(
                label: l10n.experienceYearsLabel,
                controller: experienceController,
                iconPath: 'assets/images/icons8-certificate-72.png',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _experienceSuggestions
                    .map(
                      (entry) => _QuickFillChip(
                        label: entry.key,
                        onTap: () => experienceController.text = entry.value,
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 14.h),
              TechnicianProfileLabeledField(
                label: l10n.hourlyRateLabel,
                controller: hourlyRateController,
                iconPath: 'assets/images/icons8-money-64.png',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickFillChip extends StatelessWidget {
  const _QuickFillChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: AppColors.lightPrimary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.lightPrimary.withValues(alpha: 0.35),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.lightPrimary,
          ),
        ),
      ),
    );
  }
}
