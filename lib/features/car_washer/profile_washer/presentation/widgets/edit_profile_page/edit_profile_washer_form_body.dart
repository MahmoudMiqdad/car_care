import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/edit_profile_page/edit_profile_washer_actions_row.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/edit_profile_page/edit_profile_washer_avatar_section.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/edit_profile_page/edit_profile_washer_labeled_field.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/edit_profile_page/edit_profile_washer_services_section.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/edit_profile_page/edit_profile_washer_work_hours_row.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileWasherFormBody extends StatelessWidget {
  const EditProfileWasherFormBody({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.workStartController,
    required this.workEndController,
    required this.descriptionController,
    required this.basicPriceController,
    required this.vipPriceController,
    required this.premiumPriceController,
    this.onCancel,
    this.onSave,
    this.onAvatarAction,
    this.avatarNetworkImageUrl,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController workStartController;
  final TextEditingController workEndController;
  final TextEditingController descriptionController;
  final TextEditingController basicPriceController;
  final TextEditingController vipPriceController;
  final TextEditingController premiumPriceController;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;
  final VoidCallback? onAvatarAction;
  final String? avatarNetworkImageUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditProfileWasherAvatarSection(
            networkImageUrl: avatarNetworkImageUrl,
            onAddPhotoTap: onAvatarAction,
          ),
          SizedBox(height: 8.h),
          EditProfileWasherLabeledField(
            label: l10n.profileWasherFieldWasherName,
            hint: l10n.profileWasherHintWasherName,
            controller: nameController,
            leadingIcon: Icon(
              Icons.short_text_rounded,
              color: AppColors.carWashTeal,
              size: 26.sp,
            ),
          ),
          SizedBox(height: 8.h),
          EditProfileWasherLabeledField(
            label: l10n.profileWasherFieldPhone,
            hint: l10n.profileWasherHintPhone,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            leadingIcon: Icon(
              Icons.phone_outlined,
              color: AppColors.carWashTeal,
              size: 22.sp,
            ),
          ),
          SizedBox(height: 8.h),
          EditProfileWasherLabeledField(
            label: l10n.profileWasherFieldAddress,
            hint: l10n.profileWasherHintAddress,
            controller: addressController,
            leadingIcon: Icon(
              Icons.location_on_outlined,
              color: AppColors.carWashTeal,
              size: 22.sp,
            ),
          ),
          SizedBox(height: 8.h),
          EditProfileWasherWorkHoursRow(
            startLabel: l10n.profileWasherFieldWorkStart,
            startHint: l10n.profileWasherHintWorkStart,
            endLabel: l10n.profileWasherFieldWorkEnd,
            endHint: l10n.profileWasherHintWorkEnd,
            startController: workStartController,
            endController: workEndController,
          ),
          SizedBox(height: 10.h),
          EditProfileWasherServicesSection(
            sectionTitle: l10n.profileWasherChooseServicesTitle,
            descriptionLabel: l10n.profileWasherFieldDescription,
            descriptionHint: l10n.profileWasherHintDescription,
            basicTitle: l10n.profileWasherTierBasic,
            vipTitle: l10n.profileWasherTierVip,
            premiumTitle: l10n.profileWasherTierPremium,
            priceLabel: l10n.profileWasherFieldPrice,
            priceHint: l10n.profileWasherHintPrice,
            descriptionController: descriptionController,
            basicPriceController: basicPriceController,
            vipPriceController: vipPriceController,
            premiumPriceController: premiumPriceController,
          ),
          SizedBox(height: 24.h),
          EditProfileWasherActionsRow(
            cancelLabel: l10n.cancel,
            saveLabel: l10n.profileWasherSaveChanges,
            onCancel: onCancel,
            onSave: onSave,
          ),
        ],
      ),
    );
  }
}
