import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

void showTechnicianEntrySheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      final strings = sheetContext.l10n;
      return Padding(
        padding: EdgeInsets.fromLTRB(
          16.w,
          0,
          16.w,
          16.h + MediaQuery.paddingOf(sheetContext).bottom,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400.w),
            child: InkWell(
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push(Routes.technicianprofile);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.engineering_outlined,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Text(
                        strings.enterAsTechnician,
                        style: Theme.of(sheetContext).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.lightTextPrimary,
                            ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.lightTextSecondary.withValues(alpha: 0.6),
                      size: 22.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
