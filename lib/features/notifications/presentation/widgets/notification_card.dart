import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/relative_time_formatter.dart';
import 'package:car_care/features/notifications/domain/entities/notification_entity.dart';
import 'package:car_care/features/notifications/presentation/widgets/notification_icon_mapping.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.isMarking,
    required this.isDeleting,
    required this.onTap,
    required this.onDelete,
  });

  final NotificationEntity notification;
  final bool isMarking;
  final bool isDeleting;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final isUnread = notification.isUnread;
    final iconColor = isUnread
        ? AppColors.accent
        : NotificationIconMapping.colorFor(notification.type);

    return Opacity(
      opacity: isDeleting ? 0.5 : 1,
      child: Material(
        color: isUnread
            ? AppColors.secondary
            : AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: isDeleting ? null : onTap,
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    NotificationIconMapping.iconFor(notification.type),
                    color: iconColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isUnread)
                            Container(
                              width: 7.w,
                              height: 7.w,
                              margin: EdgeInsetsDirectional.only(end: 6.w),
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              notification.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: isUnread
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        notification.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        formatRelativeTime(context, notification.createdAt),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isMarking)
                  SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    tooltip: strings.deleteNotification,
                    onPressed: isDeleting ? null : onDelete,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 20.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
