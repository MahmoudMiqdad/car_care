// نافذة اختيار مفرد — نفس نمط SelectOptionsSheet (تخصصات المتجر): مقبض
// سحب، عنوان، قائمة قابلة للتمرير، زر «تأكيد الاختيار»، وSafeArea. الفرق أن
// الاختيار هنا مفرد (قيمة واحدة) لا متعدد.
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleSelectOptionsSheet<T> extends StatefulWidget {
  const SingleSelectOptionsSheet({
    super.key,
    required this.title,
    required this.items,
    required this.currentValue,
  });

  final String title;
  final List<(T value, String label)> items;
  final T currentValue;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<(T value, String label)> items,
    required T currentValue,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SingleSelectOptionsSheet<T>(
        title: title,
        items: items,
        currentValue: currentValue,
      ),
    );
  }

  @override
  State<SingleSelectOptionsSheet<T>> createState() =>
      _SingleSelectOptionsSheetState<T>();
}

class _SingleSelectOptionsSheetState<T>
    extends State<SingleSelectOptionsSheet<T>> {
  late T _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              widget.title,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.lightTextPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.items.length,
                separatorBuilder: (_, _) =>
                    Divider(color: AppColors.lightBorder, height: 1),
                itemBuilder: (_, index) {
                  final item = widget.items[index];
                  final isSelected = item.$1 == _selected;
                  return InkWell(
                    onTap: () => setState(() => _selected = item.$1),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.$2,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            size: 22.sp,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.lightBorder,
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
                onPressed: () => Navigator.pop(context, _selected),
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
                  'تأكيد الاختيار',
                  style: AppTypography.labelLarge.copyWith(
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
