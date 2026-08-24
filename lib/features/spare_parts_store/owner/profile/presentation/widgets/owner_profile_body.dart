import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';

import 'package:car_care/features/spare_parts_store/owner/profile/data/static/spare_parts_options.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/widgets/owner_basic_info_section.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/widgets/owner_selection_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerProfileBody extends StatelessWidget {
  const OwnerProfileBody({
    super.key,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.cityCtrl,
    required this.selectedTypeIds,
    required this.selectedBrandIds,
    required this.selectedCategoryIds,
    required this.onTypeIdsChanged,
    required this.onBrandIdsChanged,
    required this.onCategoryIdsChanged,
    required this.onSave,
    required this.isNew,
    required this.isEnabled,
    required this.isSaving,
    this.unknownValues = const [],
    this.status,
  });

  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController cityCtrl;
  final List<int> selectedTypeIds;
  final List<int> selectedBrandIds;
  final List<int> selectedCategoryIds;
  final ValueChanged<List<int>> onTypeIdsChanged;
  final ValueChanged<List<int>> onBrandIdsChanged;
  final ValueChanged<List<int>> onCategoryIdsChanged;
  final VoidCallback onSave;
  final bool isNew;
  final bool isEnabled;
  final bool isSaving;
  final List<String> unknownValues;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _SectionLabel(l10n.shopNameLabel)),
              if (!isNew) _StatusChip(status: status),
            ],
          ),
          SizedBox(height: 12.h),
          OwnerBasicInfoSection(
            nameCtrl: nameCtrl,
            phoneCtrl: phoneCtrl,
            cityCtrl: cityCtrl,
            isEnabled: isEnabled,
          ),
          if (isNew) ...[
            SizedBox(height: 28.h),
            _SectionLabel(l10n.shopDetailsPageTitle),
            SizedBox(height: 12.h),
            OwnerSelectionCard(
              title: l10n.businessTypeLabel,
              allOptions: SparePartsOptions.businessTypes,
              selectedIds: selectedTypeIds,
              isEnabled: isEnabled,
              onChanged: onTypeIdsChanged,
              chipColor: AppColors.accent,
            ),
            SizedBox(height: 12.h),
            OwnerSelectionCard(
              title: l10n.carBrandsLabel,
              allOptions: SparePartsOptions.carBrands,
              selectedIds: selectedBrandIds,
              isEnabled: isEnabled,
              onChanged: onBrandIdsChanged,
              chipColor: AppColors.green,
            ),
            SizedBox(height: 12.h),
            OwnerSelectionCard(
              title: l10n.partCategoriesLabel,
              allOptions: SparePartsOptions.partCategories,
              selectedIds: selectedCategoryIds,
              isEnabled: isEnabled,
              onChanged: onCategoryIdsChanged,
              chipColor: AppColors.primary,
            ),
          ],
          SizedBox(height: 24.h),
          if (unknownValues.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    color: AppColors.warning,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      l10n.unknownProfileValuesError(unknownValues.join("، ")),
                      style: context.textTheme.labelSmall!.copyWith(
                        color: AppColors.warning,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
          ],
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (isEnabled && unknownValues.isEmpty) ? onSave : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: isSaving
                  ? SizedBox(
                      width: 22.sp,
                      height: 22.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.white,
                      ),
                    )
                  : Text(
                      isNew ? l10n.saveChangesButtonLabel : l10n.updateProduct,
                      style: context.textTheme.labelLarge!.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isApproved = status == 'approved';
    final color = isApproved ? AppColors.green : AppColors.textSecondary(context);
    final label = isApproved ? l10n.activeStatus : (status ?? l10n.unknownStatus);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall!.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.labelMedium!.copyWith(
        color: AppColors.textPrimary(context),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
