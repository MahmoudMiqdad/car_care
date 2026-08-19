import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SharedSelectionBottomSheet<T> extends StatelessWidget {
  const SharedSelectionBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onSelected,
    this.emptyState,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.3,
    this.maxChildSize = 0.8,
    this.rtl = true,
  });

  final String title;
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final ValueChanged<T> onSelected;
  final Widget? emptyState;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final bool rtl;

 
  static Future<void> show<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required Widget Function(BuildContext context, T item) itemBuilder,
    required ValueChanged<T> onSelected,
    Widget? emptyState,
    double initialChildSize = 0.5,
    double minChildSize = 0.3,
    double maxChildSize = 0.8,
    bool rtl = true,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SharedSelectionBottomSheet<T>(
        title: title,
        items: items,
        itemBuilder: itemBuilder,
        onSelected: onSelected,
        emptyState: emptyState,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        rtl: rtl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      expand: false,
      builder: (sheetContext, scrollController) => Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 14.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: items.isEmpty
                  ? (emptyState ?? const SizedBox.shrink())
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: items.length,
                      itemBuilder: (itemContext, index) {
                        final item = items[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(12.r),
                          onTap: () {
                            onSelected(item);
                            Navigator.of(context).pop();
                          },
                          child: itemBuilder(itemContext, item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );

    return rtl
        ? Directionality(textDirection: TextDirection.rtl, child: content)
        : content;
  }
}
