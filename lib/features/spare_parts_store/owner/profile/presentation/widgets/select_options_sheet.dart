import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/data/static/spare_parts_options.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectOptionsSheet extends StatefulWidget {
  const SelectOptionsSheet({
    super.key,
    required this.title,
    required this.options,
    required this.currentSelection,
  });

  final String title;
  final List<SparePartsOption> options;
  final List<int> currentSelection;

  static Future<List<int>?> show(
    BuildContext context, {
    required String title,
    required List<SparePartsOption> options,
    required List<int> currentSelection,
  }) {
    return showModalBottomSheet<List<int>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => SelectOptionsSheet(
        title: title,
        options: options,
        currentSelection: currentSelection,
      ),
    );
  }

  @override
  State<SelectOptionsSheet> createState() => _SelectOptionsSheetState();
}

class _SelectOptionsSheetState extends State<SelectOptionsSheet> {
  late Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.of(widget.currentSelection);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.75.sh),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.border(context),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              widget.title,
              style: context.textTheme.labelLarge!.copyWith(
                color: AppColors.textPrimary(context),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.options.length,
                separatorBuilder: (_, _) =>
                    Divider(color: AppColors.border(context), height: 1),
                itemBuilder: (_, index) {
                  final option = widget.options[index];
                  final isSelected = _selected.contains(option.id);
                  return InkWell(
                    onTap: () => setState(() {
                      if (isSelected) {
                        _selected.remove(option.id);
                      } else {
                        _selected.add(option.id);
                      }
                    }),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option.name,
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 22.sp,
                            height: 22.sp,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border(context),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    size: 14.sp,
                                    color: AppColors.white,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _selected.toList()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  l10n.confirmMultiSelectionCount(_selected.length),
                  style: context.textTheme.labelLarge!.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
