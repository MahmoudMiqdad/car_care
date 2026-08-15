// بطاقة تخصص واحدة (نوع النشاط / ماركات السيارات / فئات القطع) لصفحة تخصصات المتجر.
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/data/static/spare_parts_options.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/widgets/select_options_sheet.dart';
import 'package:car_care/features/spare_parts_store/shared/presentation/widgets/store_attribute_chip.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerSpecializationCard extends StatelessWidget {
  const OwnerSpecializationCard({
    super.key,
    required this.title,
    required this.allOptions,
    required this.selectedIds,
    required this.attributeType,
    required this.isEnabled,
    required this.onChanged,
  });

  final String title;
  final List<SparePartsOption> allOptions;
  final List<int> selectedIds;
  final StoreAttributeType attributeType;
  final bool isEnabled;

  /// يُستدعى فقط عندما يختلف الاختيار الجديد فعليًا عن [selectedIds].
  final ValueChanged<List<int>> onChanged;

  bool _sameSelection(List<int> a, List<int> b) {
    final sortedA = List.of(a)..sort();
    final sortedB = List.of(b)..sort();
    return listEquals(sortedA, sortedB);
  }

  @override
  Widget build(BuildContext context) {
    final selected = selectedIds
        .map((id) => SparePartsOptions.findById(allOptions, id))
        .whereType<SparePartsOption>()
        .toList();

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.lightTextPrimary,
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
                        if (result != null &&
                            !_sameSelection(result, selectedIds)) {
                          onChanged(result);
                        }
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF5F6B76),
                  backgroundColor: const Color(0xFFF7F8F9),
                  side: const BorderSide(color: Color(0xFFB8C0C8)),
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
                      Icons.edit_outlined,
                      size: 13.sp,
                      color: const Color(0xFF5F6B76),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'تعديل',
                      style: AppTypography.labelSmall.copyWith(
                        color: const Color(0xFF5F6B76),
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
                  'لم يتم الاختيار بعد',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.lightTextSecondary,
                  ),
                )
              : Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: selected
                      .map(
                        (opt) => StoreAttributeChip(
                          label: opt.name,
                          type: attributeType,
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }
}
