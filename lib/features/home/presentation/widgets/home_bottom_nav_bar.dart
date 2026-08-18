import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/features/home/presentation/widgets/home_palette.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    this.onItemSelected,
    this.activeIndex = 0,
    this.notificationsBadgeCount,
  });

  final ValueChanged<int>? onItemSelected;

  final int activeIndex;

  /// Unread notifications count shown on the notifications tab badge.
  final int? notificationsBadgeCount;

  /// Compact colored-bar height, excluding the device bottom safe inset.
  static const double _barHeight = 44;

  /// Horizontal floating margin applied to both sides of the pill.
  static const double _horizontalMargin = 16;

  /// Corner radius matching the reference design's rounder pill.
  static const double _cornerRadius = 28;

  /// Small, shallow gap between the notch curve and the assistant button.
  static const double _notchMargin = 8;

  /// Reserved width for the centered notch/button gap.
  static const double _centerGap = 72;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    // Padding/ClipRRect layer so the BottomAppBar's own notched background
    // never has to paint square/full-width, and nothing opaque sits behind
    // the notch. The device bottom safe-area inset is applied exactly once,
    // right here — plus a small fixed visual lift so the bar never sits
    // flush against the system navigation area.
    final liftedBottomInset = bottomInset > 0 ? bottomInset + 8.h : 10.h;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        _horizontalMargin.w,
        0,
        _horizontalMargin.w,
        liftedBottomInset,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_cornerRadius.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_cornerRadius.r),
          // The outer Padding above already accounts for the safe-area
          // bottom inset once; strip it here so BottomAppBar doesn't apply
          // it again internally and inflate the colored bar's height.
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: BottomAppBar(
              color: HomePalette.primaryTeal,
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
              notchMargin: _notchMargin.r,
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: HomeBottomNavItem(
                              icon: Icons.home_filled,
                              label: strings.home,
                              isActive: activeIndex == 0,
                              onTap: () => onItemSelected?.call(0),
                            ),
                          ),
                          Flexible(
                            child: HomeBottomNavItem(
                              icon: Icons.notifications,
                              label: strings.notification,
                              isActive: activeIndex == 1,
                              badgeCount: notificationsBadgeCount,
                              onTap: () => onItemSelected?.call(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Reserved gap for the centered AI button's notch.
                    SizedBox(width: _centerGap.w),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: HomeBottomNavItem(
                              icon: Icons.sos_rounded,
                              label: strings.sos,
                              isActive: activeIndex == 2,
                              onTap: () => onItemSelected?.call(2),
                            ),
                          ),
                          Flexible(
                            child: HomeBottomNavItem(
                              icon: Icons.engineering_outlined,
                              label: strings.more,
                              isActive: activeIndex == 3,
                              onTap: () => onItemSelected?.call(3),
                            ),
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
    final Color iconColor = isActive ? HomePalette.accentOrange : Colors.white;

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: iconColor, size: 20.sp),
              if (badgeCount != null && badgeCount! > 0)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: HomePalette.accentOrange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(
              color: isActive ? HomePalette.accentOrange : Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
