import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    this.onItemSelected,
  });

  final ValueChanged<int>? onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.r,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HomeBottomNavItem(
            icon: Icons.home_filled,
            label: 'Home',
            isActive: true,
            onTap: () => onItemSelected?.call(0),
          ),
          HomeBottomNavItem(
            icon: Icons.notifications,
            label: 'Notification',
            badgeCount: 2,
            onTap: () => onItemSelected?.call(1),
          ),
          HomeBottomNavItem(
            icon: Icons.chat_bubble_outline,
            label: 'Messages',
            onTap: () => onItemSelected?.call(2),
          ),
          HomeBottomNavItem(
            icon: Icons.more_horiz,
            label: 'More',
            onTap: () => onItemSelected?.call(3),
          ),
        ],
      ),
    );
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
              Icon(
                icon,
                color: iconColor,
                size: 24.sp,
              ),
              if (badgeCount != null && badgeCount! > 0)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
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

