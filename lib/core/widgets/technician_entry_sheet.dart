import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
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

      Widget entryItem({
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
        return InkWell(
          onTap: () {
            Navigator.of(sheetContext).pop();
            onTap();
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
                  child: Icon(icon, color: AppColors.primary, size: 24.sp),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(sheetContext).textTheme.titleSmall
                        ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary(context),
                        ),
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.textSecondary(
                    context,
                  ).withValues(alpha: 0.6),
                  size: 22.sp,
                ),
              ],
            ),
          ),
        );
      }

      return FutureBuilder<String?>(
        future: getIt<SecureStorage>().getPrimaryRole(),
        builder: (_, snap) {
          final role = snap.data ?? '';

          return Padding(
            padding: EdgeInsets.fromLTRB(
              16.w,
              0,
              16.w,
              16.h + MediaQuery.paddingOf(sheetContext).bottom,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(16.r),
              color: sheetContext.colorScheme.surfaceContainer,
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    entryItem(
                      icon: Icons.engineering_outlined,
                      label: strings.enterAsTechnician,
                      onTap: () => context.push(
                        role == 'technician'
                            ? Routes.orders
                            : Routes.inserttechnicianprofile,
                      ),
                    ),
                    Divider(height: 1.h, indent: 16.w, endIndent: 16.w),
                    entryItem(
                      icon: Icons.local_car_wash_outlined,
                      label: 'الدخول كـ مغسلة',
                      onTap: () => context.push(
                        role == 'car-washer'
                            ? Routes.profile_washer
                            : Routes.create_profile_washer,
                      ),
                    ),
                    Divider(height: 1.h, indent: 16.w, endIndent: 16.w),
                    entryItem(
                      icon: Icons.local_gas_station_outlined,
                      label: 'الدخول كـ مزود وقود',
                      onTap: () => context.push(
                        role == 'fuel-provider'
                            ? Routes.provider_profile
                            : Routes.provider_create_profile,
                      ),
                    ),
                    Divider(height: 1.h, indent: 16.w, endIndent: 16.w),
                    entryItem(
                      icon: Icons.store_outlined,
                      label: 'الدخول كصاحب متجر',
                      onTap: () => context.push(Routes.ownerProfile),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
