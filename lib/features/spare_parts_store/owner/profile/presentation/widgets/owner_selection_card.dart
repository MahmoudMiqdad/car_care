import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/data/static/spare_parts_options.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/widgets/select_options_sheet.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerSelectionCard extends StatelessWidget {
  const OwnerSelectionCard({
    super.key,
    required this.title,
    required this.allOptions,
    required this.selectedIds,
    required this.onChanged,
    required this.isEnabled,
    this.chipColor = AppColors.primary,
  });

  final String title;
  final List<SparePartsOption> allOptions;
  final List<int> selectedIds;
  final ValueChanged<List<int>> onChanged;
  final bool isEnabled;
  final Color chipColor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = selectedIds
        .map((id) => SparePartsOptions.findById(allOptions, id))
        .whereType<SparePartsOption>()
        .toList();

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.labelMedium!.copyWith(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: isEnabled
                    ? () async {
                        final result = await SelectOptionsSheet.show(
                          context,
                          title: title,
                          options: allOptions,
                          currentSelection: selectedIds,
                        );
                        if (result != null) onChanged(result);
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary(context),
                  backgroundColor: AppColors.secondary,
                  side: BorderSide(color: AppColors.border(context)),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      selectedIds.isEmpty
                          ? Icons.add_rounded
                          : Icons.edit_outlined,
                      size: 13.sp,
                      color: AppColors.textSecondary(context),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      selectedIds.isEmpty
                          ? l10n.chooseActionLabel
                          : l10n.editButtonLabel,
                      style: context.textTheme.labelSmall!.copyWith(
                        color: AppColors.textSecondary(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          selected.isEmpty
              ? Text(
                  l10n.noSelectionMadeYet,
                  style: context.textTheme.labelSmall!.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                )
              : Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: selected
                      .map(
                        (opt) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: chipColor.withValues(alpha: 0.09),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: chipColor.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Text(
                            opt.name,
                            style: context.textTheme.labelSmall!.copyWith(
                              color: chipColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }
}
