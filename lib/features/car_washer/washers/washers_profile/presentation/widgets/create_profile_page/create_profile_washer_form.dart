import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/create_profile_page/create_profile_washer_basic_section.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/create_profile_page/create_profile_washer_logo_section.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/create_profile_page/create_profile_washer_services_section.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/create_profile_page/create_profile_washer_work_hours_section.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/edit_profile_page/edit_profile_washer_actions_row.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateProfileWasherForm extends StatelessWidget {
  const CreateProfileWasherForm({
    super.key,
    required this.isLoading,
    required this.logoPath,
    required this.shopController,
    required this.phoneController,
    required this.cityController,
    required this.addressController,
    required this.descriptionController,
    required this.servicesController,
    required this.basicController,
    required this.vipController,
    required this.premiumController,
    required this.workStartController,
    required this.workEndController,
    required this.onWorkStartTimeTap,
    required this.onWorkEndTimeTap,
    required this.onPickLogo,
    required this.onSave,
  });

  final bool isLoading;
  final String? logoPath;
  final TextEditingController shopController;
  final TextEditingController phoneController;
  final TextEditingController cityController;
  final TextEditingController addressController;
  final TextEditingController descriptionController;
  final TextEditingController servicesController;
  final TextEditingController basicController;
  final TextEditingController vipController;
  final TextEditingController premiumController;
  final TextEditingController workStartController;
  final TextEditingController workEndController;
  final VoidCallback onWorkStartTimeTap;
  final VoidCallback onWorkEndTimeTap;
  final VoidCallback? onPickLogo;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CreateProfileWasherLogoSection(
                logoPath: logoPath,
                onTap: isLoading ? null : onPickLogo,
                uploadLabel: l10n.profileWasherUploadLogo,
              ),
              SizedBox(height: 12.h),
              CreateProfileWasherBasicSection(
                shopNameLabel: l10n.profileWasherFieldWasherName,
                shopNameHint: l10n.profileWasherHintWasherName,
                phoneLabel: l10n.profileWasherFieldPhone,
                phoneHint: l10n.profileWasherHintPhone,
                cityLabel: l10n.profileWasherFieldCity,
                cityHint: l10n.profileWasherHintCity,
                addressLabel: l10n.profileWasherFieldStreetAddress,
                addressHint: l10n.profileWasherHintStreetAddress,
                shopController: shopController,
                phoneController: phoneController,
                cityController: cityController,
                addressController: addressController,
              ),
              SizedBox(height: 10.h),
              CreateProfileWasherServicesSection(
                servicesLabel: l10n.profileWasherFieldServicesList,
                servicesHint: l10n.profileWasherHintServicesList,
                sectionTitle: l10n.profileWasherChooseServicesTitle,
                descriptionLabel: l10n.profileWasherFieldDescription,
                descriptionHint: l10n.profileWasherHintDescription,
                basicTitle: l10n.profileWasherTierBasic,
                vipTitle: l10n.profileWasherTierVip,
                premiumTitle: l10n.profileWasherTierPremium,
                priceLabel: l10n.profileWasherFieldPrice,
                priceHint: l10n.profileWasherHintPrice,
                servicesController: servicesController,
                descriptionController: descriptionController,
                basicPriceController: basicController,
                vipPriceController: vipController,
                premiumPriceController: premiumController,
              ),
              SizedBox(height: 10.h),
              CreateProfileWasherWorkHoursSection(
                sectionTitle: l10n.profileWasherWorkingHoursTitle,
                startLabel: l10n.profileWasherFieldWorkStart,
                startHint: l10n.profileWasherHintWorkStart,
                endLabel: l10n.profileWasherFieldWorkEnd,
                endHint: l10n.profileWasherHintWorkEnd,
                startController: workStartController,
                endController: workEndController,
                onStartTimeTap: onWorkStartTimeTap,
                onEndTimeTap: onWorkEndTimeTap,
                enabled: !isLoading,
              ),
              SizedBox(height: 24.h),
              EditProfileWasherActionsRow(
                saveLabel: l10n.profileWasherCreateSave,
                cancelLabel: l10n.cancel,
                onSave: isLoading ? null : onSave,
                onCancel: isLoading
                    ? null
                    : () => context.safePopOrGo(Routes.more),
              ),
            ],
          ),
        ),
        if (isLoading)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x33000000),
              child: Center(child: AppLoadingWidget()),
            ),
          ),
      ],
    );
  }
}
