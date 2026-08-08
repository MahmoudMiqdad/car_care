import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    this.onItemSelected,
    this.activeIndex = 0,
  });

  final ValueChanged<int>? onItemSelected;

  final int activeIndex;

  /// Compact colored-bar height, excluding the device bottom safe inset.
  static const double _barHeight = 78;

  /// Horizontal floating margin applied to both sides of the pill.
  static const double _horizontalMargin = 16;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    // Floating pill: horizontal margin + rounded corners live on this outer
    // Padding/ClipRRect layer so the BottomAppBar's own notched background
    // never has to paint square/full-width, and nothing opaque sits behind
    // the notch. The device bottom safe-area inset is applied exactly once,
    // right here.
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _horizontalMargin.w,
        0,
        _horizontalMargin.w,
        bottomInset > 0 ? bottomInset : 10.h,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.r),
          // The outer Padding above already accounts for the safe-area
          // bottom inset once; strip it here so BottomAppBar doesn't apply
          // it again internally and inflate the colored bar's height.
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: BottomAppBar(
              color: AppColors.primary,
              elevation: 0,
              height: _barHeight.h,
              padding: EdgeInsets.zero,
              // CircularNotchedRectangle receives the FAB's rect in
              // Scaffold-global coordinates but only ever gets the
              // BottomAppBar's own *local* rect as `host`. Since this bar is
              // shifted right by [_horizontalMargin] from the screen edge,
              // the raw notch would land off-center by that same amount —
              // this wrapper cancels it out so the notch always tracks the
              // FAB's true screen-center position.
              shape: _CenteredNotchedShape(
                horizontalInset: _horizontalMargin.w,
              ),
              notchMargin: 10.r,
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          HomeBottomNavItem(
                            icon: Icons.home_filled,
                            label: strings.home,
                            isActive: activeIndex == 0,
                            onTap: () => onItemSelected?.call(0),
                          ),
                          HomeBottomNavItem(
                            icon: Icons.notifications,
                            label: strings.notification,
                            isActive: activeIndex == 1,
                            onTap: () => onItemSelected?.call(1),
                          ),
                        ],
                      ),
                    ),
                    // Reserved gap for the centered AI button's notch.
                    SizedBox(width: 84.w),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          HomeBottomNavItem(
                            icon: Icons.assignment_outlined,
                            label: strings.activeorders,
                            isActive: activeIndex == 2,
                            onTap: () => onItemSelected?.call(2),
                          ),
                          HomeBottomNavItem(
                            icon: Icons.engineering_outlined,
                            label: strings.more,
                            isActive: activeIndex == 3,
                            onTap: () => onItemSelected?.call(3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Delegates to [CircularNotchedRectangle] after translating the guest (FAB)
/// rect left by [horizontalInset], correcting for the BottomAppBar being
/// inset from the screen edge by that same amount (see usage above).
class _CenteredNotchedShape extends NotchedShape {
  const _CenteredNotchedShape({required this.horizontalInset});

  final double horizontalInset;

  static const CircularNotchedRectangle _delegate = CircularNotchedRectangle();

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    final adjustedGuest = guest?.translate(-horizontalInset, 0);
    return _delegate.getOuterPath(host, adjustedGuest);
  }
}

class HomeBottomNavItem extends StatelessWidget {
  const HomeBottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.badgeCount,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final int? badgeCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isActive ? AppColors.orange : Colors.white;

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: iconColor, size: 24.sp),
              if (badgeCount != null && badgeCount! > 0)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: isActive ? AppColors.orange : Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
