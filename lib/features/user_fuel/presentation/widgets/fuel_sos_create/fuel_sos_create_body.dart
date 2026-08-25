import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/selection/select_trigger_field.dart';
import 'package:car_care/features/sos/presentation/widgets/create_sos/create_sos_location_hint.dart';
import 'package:car_care/features/user_fuel/presentation/widgets/fuel_sos_create/fuel_sos_create_field_icon.dart';
import 'package:car_care/features/user_fuel/presentation/widgets/fuel_sos_create/fuel_sos_create_illustration.dart';
import 'package:car_care/features/user_fuel/presentation/widgets/fuel_sos_create/fuel_sos_create_text_field.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FuelSosCreateBody extends StatelessWidget {
  const FuelSosCreateBody({
    super.key,
    required this.vehicleValue,
    required this.fuelTypeValue,
    required this.provinceValue,
    required this.quantityController,
    required this.notesController,
    required this.onPickVehicle,
    required this.onPickFuelType,
    required this.onPickProvince,
    required this.onSubmit,
    this.isLoading = false,
  });

  final String? vehicleValue;
  final String? fuelTypeValue;
  final String? provinceValue;
  final TextEditingController quantityController;
  final TextEditingController notesController;
  final VoidCallback onPickVehicle;
  final VoidCallback onPickFuelType;
  final VoidCallback onPickProvince;
  final VoidCallback onSubmit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FuelSosCreateIllustration(),
            SelectTriggerField(
              leading: const FuelSosCreateFieldIcon(
                assetPath: AppAssets.fuelSosCreateVehicleIcon,
              ),
              label: l10n.fuelSosCreateVehicleTitle,
              placeholder: l10n.fuelSosCreateVehicleHint,
              labelColor: AppColors.primary,
              labelHeight: 1.35,
              valueHeight: 1.45,
              value: vehicleValue,
              onTap: isLoading ? () {} : onPickVehicle,
            ),
            SizedBox(height: 8.h),
            SelectTriggerField(
              leading: const FuelSosCreateFieldIcon(
                assetPath: AppAssets.fuelSosCreateFuelTypeIcon,
              ),
              label: l10n.fuelSosCreateFuelTypeTitle,
              placeholder: l10n.fuelSosCreateFuelTypeHint,
              labelColor: AppColors.primary,
              labelHeight: 1.35,
              valueHeight: 1.45,
              value: fuelTypeValue,
              onTap: isLoading ? () {} : onPickFuelType,
            ),
            SizedBox(height: 8.h),
            FuelSosCreateTextField(
              iconAsset: AppAssets.fuelSosCreateQuantityIcon,
              title: l10n.fuelSosCreateQuantityTitle,
              hint: l10n.fuelSosCreateQuantityHint,
              controller: quantityController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              ],
            ),
            SizedBox(height: 8.h),
            FuelSosCreateTextField(
              iconAsset: AppAssets.fuelSosCreateNotesIcon,
              title: l10n.fuelSosCreateNotesTitle,
              hint: l10n.fuelSosCreateNotesHint,
              controller: notesController,
              maxLines: 2,
            ),
            SizedBox(height: 8.h),
            SelectTriggerField(
              leading: const FuelSosCreateFieldIcon(
                assetPath: AppAssets.iconLocationPin,
              ),
              label: l10n.fuelSosCreateProvinceTitle,
              placeholder: l10n.fuelSosCreateProvinceHint,
              labelColor: AppColors.primary,
              labelHeight: 1.35,
              valueHeight: 1.45,
              value: provinceValue,
              onTap: isLoading ? () {} : onPickProvince,
            ),
            CreateSosLocationHint(text: l10n.createSosLocationAutoHint),
            SizedBox(height: 10.h),
            AppButton(
              text: isLoading
                  ? l10n.sendingRequest
                  : l10n.createSosSendRequest,
              onPressed: isLoading ? null : onSubmit,
              backgroundColor: isLoading
                  ? AppColors.accent.withOpacity(0.6)
                  : AppColors.accent,
              height: 52.h,
              borderRadius: 14.r,
            ),
          ],
        ),
      ),
    );
  }
}
