import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/widgets/provider_edit_profile/provider_edit_profile_actions.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/widgets/provider_edit_profile/provider_edit_profile_fields.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/widgets/provider_edit_profile/provider_edit_profile_fuel_section.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/widgets/provider_profile/provider_profile_cards.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProviderEditProfileBody extends StatelessWidget {
  const ProviderEditProfileBody({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.governorateValue,
    required this.onPickGovernorate,
    required this.onSave,
    required this.onCancel,
    required this.fuelPrices,
    this.onFuelTypeTap,
    this.personalInfoTitle,
    this.saveLabel,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final String? governorateValue;
  final VoidCallback onPickGovernorate;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final Map<String, String> fuelPrices;
  final void Function(String fuelType)? onFuelTypeTap;
  final String? personalInfoTitle;
  final String? saveLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppConstants.pageHorizontal,
          16.h,
          AppConstants.pageHorizontal,
          24.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProviderProfileSectionTitle(
              title: personalInfoTitle ?? l10n.providerEditProfilePersonalInfoTitle,
            ),
            SizedBox(height: 10.h),
            ProviderEditProfileInputField(
              label: l10n.providerEditProfileProviderNameLabel,
              hint: l10n.providerEditProfileProviderNameHint,
              controller: nameController,
              leading: const ProviderEditProfileFieldIcon(
                assetPath: AppAssets.technicianJobProfileIcon,
              ),
            ),
            SizedBox(height: 10.h),
            ProviderEditProfileInputField(
              label: l10n.providerEditProfileProviderPhoneLabel,
              hint: l10n.providerEditProfileProviderPhoneHint,
              controller: phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              leading: ProviderEditProfileFieldIcon(
                assetPath: AppAssets.iconPhoneCall,
              ),
            ),
            SizedBox(height: 10.h),
            ProviderEditProfileSelectField(
              label: l10n.providerEditProfileGovernorateLabel,
              hint: l10n.providerEditProfileGovernorateHint,
              value: governorateValue,
              onTap: onPickGovernorate,
            ),
            SizedBox(height: 10.h),
            ProviderEditProfileInputField(
              label: l10n.providerEditProfileAddressLabel,
              hint: l10n.providerEditProfileAddressHint,
              controller: addressController,
              maxLines: 2,
              leading: ProviderEditProfileFieldIcon(
                assetPath: AppAssets.iconLocationPin,
              ),
            ),
            SizedBox(height: 6.h),
            ProviderEditProfileLocationNote(
              text: l10n.providerEditProfileLocationNote,
            ),
            SizedBox(height: 16.h),
            ProviderEditProfileFuelServicesSection(
              fuelPrices: fuelPrices,
              onFuelTypeTap: onFuelTypeTap,
            ),
            SizedBox(height: 24.h),
            ProviderEditProfileActions(
              saveLabel: saveLabel ?? l10n.providerEditProfileSaveInfo,
              cancelLabel: l10n.cancel,
              onSave: onSave,
              onCancel: onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
