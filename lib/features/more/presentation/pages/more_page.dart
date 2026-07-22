import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getIt<SecureStorage>().getPrimaryRole(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.lightScaffold,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final role = snap.data ?? 'user';
        return _MoreContent(role: role);
      },
    );
  }
}

class _MoreContent extends StatelessWidget {
  const _MoreContent({required this.role});

  final String role;

  String get _roleLabel => switch (role) {
        'shop-owner' => 'صاحب متجر',
        'technician' => 'فني',
        'car-washer' => 'مغسلة',
        'fuel-provider' => 'مزود وقود',
        _ => 'عميل',
      };

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.lightScaffold,
      appBar: CustomAppBar(
        title: strings.more,
        showBackButton: false,
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding:
            EdgeInsets.fromLTRB(16.w, 20.h, 16.w, MediaQuery.paddingOf(context).bottom + 20.h),
        children: [
          _RoleHeader(roleLabel: _roleLabel),
          SizedBox(height: 20.h),
          ..._buildItems(context),
          SizedBox(height: 8.h),
          _LogoutTile(),
        ],
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    return switch (role) {
      'shop-owner' => _shopOwnerItems(context),
      'technician' => _technicianItems(context),
      'car-washer' => _carWasherItems(context),
      'fuel-provider' => _fuelProviderItems(context),
      _ => _customerItems(context),
    };
  }

  List<Widget> _customerItems(BuildContext context) {
    return [
      _SectionHeader(label: 'انضم كمزود خدمة'),
      _MoreTile(
        icon: Icons.engineering_outlined,
        label: 'التقديم كفني',
        iconColor: const Color(0xFF6366F1),
        onTap: () => context.push(Routes.inserttechnicianprofile),
      ),
      _MoreTile(
        icon: Icons.local_car_wash_outlined,
        label: 'تسجيل مغسلة سيارات',
        iconColor: const Color(0xFF14B8A6),
        onTap: () => context.push(Routes.create_profile_washer),
      ),
      _MoreTile(
        icon: Icons.local_gas_station_outlined,
        label: 'التسجيل كمزود وقود',
        iconColor: const Color(0xFFF59E0B),
        onTap: () => context.push(Routes.provider_create_profile),
      ),
      _MoreTile(
        icon: Icons.store_outlined,
        label: 'فتح متجر قطع غيار',
        iconColor: const Color(0xFFEC4899),
        onTap: () => context.push(Routes.ownerProfile),
      ),
    ];
  }

  List<Widget> _shopOwnerItems(BuildContext context) {
    return [
      _MoreTile(
        icon: Icons.store_outlined,
        label: 'ملف المتجر',
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.ownerProfile),
      ),
      _MoreTile(
        icon: Icons.receipt_long_outlined,
        label: 'طلبات المتجر',
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.ownerOrders),
      ),
    ];
  }

  List<Widget> _technicianItems(BuildContext context) {
    return [
      _MoreTile(
        icon: Icons.assignment_outlined,
        label: 'طلبات الصيانة',
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.orders),
      ),
      _MoreTile(
        icon: Icons.engineering_outlined,
        label: 'ملف الفني',
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.technicianProfileViewBody),
      ),
      _MoreTile(
        icon: Icons.emergency_outlined,
        label: 'طلبات SOS الفني',
        iconColor: AppColors.error,
        onTap: () => context.push(Routes.technician_sos_requests),
      ),
      _MoreTile(
        icon: Icons.bar_chart_outlined,
        label: 'تقارير الأعمال',
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.technician_statistics),
      ),
    ];
  }

  List<Widget> _carWasherItems(BuildContext context) {
    return [
      _MoreTile(
        icon: Icons.local_car_wash_outlined,
        label: 'ملف المغسلة',
        iconColor: AppColors.carWashTeal,
        onTap: () => context.push(Routes.profile_washer),
      ),
      _MoreTile(
        icon: Icons.calendar_month_outlined,
        label: 'الحجوزات',
        iconColor: AppColors.carWashTeal,
        onTap: () => context.push(Routes.washerBookings),
      ),
      _MoreTile(
        icon: Icons.toggle_on_outlined,
        label: 'التوفر',
        iconColor: AppColors.carWashTeal,
        onTap: () => context.push(Routes.availability),
      ),
      // washer_statistics GoRoute is commented out in app_router — omitted
    ];
  }

  List<Widget> _fuelProviderItems(BuildContext context) {
    return [
      _MoreTile(
        icon: Icons.local_gas_station_outlined,
        label: 'ملف مزود الوقود',
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.provider_profile),
      ),
      _MoreTile(
        icon: Icons.receipt_long_outlined,
        label: 'طلبات الوقود',
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.provider_order),
      ),
      _MoreTile(
        icon: Icons.share_location_outlined,
        label: 'مشاركة الموقع',
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.share_location_fuel),
      ),
    ];
  }
}

class _RoleHeader extends StatelessWidget {
  const _RoleHeader({required this.roleLabel});

  final String roleLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF004D63)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_outline_rounded, color: Colors.white, size: 28.sp),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الخيارات',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  roleLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 4.w, top: 4.h, bottom: 6.h),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(9.r),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, color: iconColor, size: 21.sp),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextPrimary,
                        ),
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.lightTextSecondary.withValues(alpha: 0.5),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoutTile extends StatelessWidget {
  const _LogoutTile();

  Future<void> _confirmLogout(BuildContext context) async {
    final strings = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.logout),
        content: Text(strings.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(strings.logout),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await getIt<SecureStorage>().clearAuth();
    if (!context.mounted) return;
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: () => _confirmLogout(context),
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(9.r),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.logout_rounded, color: AppColors.error, size: 21.sp),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    strings.logout,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
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
