import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatTileData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatTileData({
    required this.title,
    required this.value,
    required this.icon,
    this.color = AppColors.primary,
  });
}

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key, required this.items});

  final List<StatTileData> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final gap = 10.w;
        final half = (w - gap) / 2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: List.generate(items.length, (i) {
            final isLastFullWidth = items.length.isOdd && i == items.length - 1;
            final itemWidth = isLastFullWidth ? w : half;

            return SizedBox(
              width: itemWidth,
              child: _StatTile(item: items[i]),
            );
          }),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.item});

  final StatTileData item;

  @override
  Widget build(BuildContext context) {
    return AppBoxContainer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(item.icon, color: item.color, size: 22.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    textDirection: TextDirection.rtl,
                    maxLines: 2, 
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item.value,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}