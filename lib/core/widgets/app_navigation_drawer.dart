import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  void _closeThen(BuildContext context, VoidCallback action) {
    Scaffold.maybeOf(context)?.closeEndDrawer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) action();
    });
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final strings = context.l10n;
    final colorScheme = context.colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(strings.logout),
        content: Text(strings.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            child: Text(strings.logout),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    Scaffold.maybeOf(context)?.closeEndDrawer();
    await getIt<SecureStorage>().clearAuth();
    if (!context.mounted) return;
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final colorScheme = context.colorScheme;

    return Drawer(
      elevation: 0,
      backgroundColor: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(24.r),
          bottomEnd: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DrawerHeader(appName: AppConstants.appName, tagline: strings.home),
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DrawerTile(
                    icon: Icons.person_outline_rounded,
                    label: strings.profile,
                    iconColor: colorScheme.primary,
                    onTap: () => _closeThen(
                      context,
                      () => context.push(Routes.user_profile),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _DrawerTile(
                    icon: Icons.notifications_outlined,
                    label: strings.notifications,
                    iconColor: colorScheme.tertiary,
                    onTap: () => _closeThen(
                      context,
                      () => context.go(Routes.notifications),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _DrawerTile(
                    icon: Icons.settings_outlined,
                    label: strings.settingsTitle,
                    iconColor: colorScheme.primary,
                    onTap: () => _closeThen(
                      context,
                      () => context.push(Routes.settings),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Divider(color: colorScheme.outlineVariant, height: 1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: _DrawerTile(
                icon: Icons.logout_rounded,
                label: strings.logout,
                iconColor: colorScheme.error,
                dense: true,
                onTap: () => _confirmLogout(context),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.appName, required this.tagline});

  final String appName;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = context.colorScheme;
    final onPrimary = colorScheme.onPrimary;
    final headerEnd = Color.lerp(colorScheme.primary, Colors.black, 0.3)!;

    return SizedBox(
      height: 172.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorScheme.primary, headerEnd],
              ),
            ),
          ),
          Positioned(
            top: -34.r,
            left: -22.r,
            child: _Bubble(size: 104.r, color: onPrimary, opacity: 0.10),
          ),
          Positioned(
            bottom: 34.h,
            right: -18.r,
            child: _Bubble(size: 66.r, color: onPrimary, opacity: 0.12),
          ),
          Positioned(
            bottom: -12.h,
            left: 64.w,
            child: _Bubble(size: 42.r, color: onPrimary, opacity: 0.14),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 52.r,
                    height: 52.r,
                    decoration: BoxDecoration(
                      color: onPrimary.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: onPrimary.withValues(alpha: 0.35),
                        width: 1.2,
                      ),
                    ),
                    child: Icon(
                      Icons.directions_car_filled_rounded,
                      color: onPrimary,
                      size: 26.sp,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    appName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: onPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    tagline,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.iconColor,
    this.dense = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      color: colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        splashColor: iconColor.withValues(alpha: 0.10),
        highlightColor: iconColor.withValues(alpha: 0.06),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: dense ? 10.h : 12.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(9.r),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: iconColor, size: 21.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
