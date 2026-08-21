import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';
import 'package:car_care/features/advertisements/presentation/widgets/advertisement_section.dart';
import 'package:car_care/features/auth/presentation/widgets/logout_action.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/cubit/owner_profile/owner_profile_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/cubit/owner_profile/owner_profile_state.dart';
import 'package:car_care/features/technician_sos/presentation/technician_sos_request_type.dart';
import 'package:car_care/features/user_profile/data/data_sources/profile_remote_data_source.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

bool showFuelProviderStatisticsTile(List<String> roles) =>
    roles.contains('fuel-provider');

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  Future<List<String>> _loadRoles() async {
    final storage = getIt<SecureStorage>();
    try {
      final model = await getIt<ProfileRemoteDataSource>().showprofile();
      final fresh = model.data?.parsedRoles ?? const <String>[];
      if (fresh.isNotEmpty) {
        await storage.setRoles(fresh);
        return fresh;
      }
    } catch (_) {}
    return storage.getRoles();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _loadRoles(),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground(context),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        final roles = snap.data ?? const <String>[];
        return _MoreContent(roles: roles);
      },
    );
  }
}

class _MoreContent extends StatelessWidget {
  const _MoreContent({required this.roles});

  final List<String> roles;

  static const _providerRoles = [
    'technician',
    'car-washer',
    'fuel-provider',
    'shop-owner',
  ];

  List<String> get _ownedProviders =>
      _providerRoles.where(roles.contains).toList();

  List<String> get _missingProviders =>
      _providerRoles.where((r) => !roles.contains(r)).toList();

  String _providerLabel(BuildContext context, String role) {
    final l10n = context.l10n;
    return switch (role) {
      'technician' => l10n.roleTechnician,
      'car-washer' => l10n.roleCarWasher,
      'fuel-provider' => l10n.roleFuelProvider,
      'shop-owner' => l10n.roleShopOwner,
      _ => role,
    };
  }

  String _roleLabel(BuildContext context) {
    final l10n = context.l10n;
    final owned = _ownedProviders;
    if (owned.isEmpty) return l10n.roleCustomer;
    return '${l10n.roleCustomer} · ${owned.map((r) => _providerLabel(context, r)).join(' · ')}';
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: CustomAppBar(
        title: strings.more,
        showBackButton: false,
        backgroundColor: AppColors.primary,
      ),
      body: ImageBackground(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16.w,
            20.h,
            16.w,
            MediaQuery.paddingOf(context).bottom + 20.h,
          ),
          children: [
            _RoleHeader(roleLabel: _roleLabel(context)),
            SizedBox(height: 20.h),
            const AdvertisementSection(
              placement: AdvertisementPlacement.general,
              height: 110,
              borderRadius: 14,
              bottomSpacing: 16,
            ),
            ..._buildItems(context),
            SizedBox(height: 8.h),
            _LogoutTile(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    final l10n = context.l10n;
    final owned = _ownedProviders;
    final missing = _missingProviders;
    return [
      if (owned.isNotEmpty) ...[
        _SectionHeader(label: l10n.myServicesAsProvider),
        for (final role in owned) ..._ownedProviderItems(context, role),
        SizedBox(height: 8.h),
      ],
      if (missing.isNotEmpty) ...[
        _SectionHeader(label: l10n.joinAsServiceProvider),
        for (final role in missing) _joinTile(context, role),
      ],
    ];
  }

  List<Widget> _ownedProviderItems(BuildContext context, String role) {
    if (role == 'shop-owner') {
      const section = _ShopOwnerSection();
      if (_ownedProviders.length == 1) return [section];
      return [_SectionHeader(label: _providerLabel(context, role)), section];
    }
    final items = switch (role) {
      'technician' => _technicianItems(context),
      'car-washer' => _carWasherItems(context),
      'fuel-provider' => _fuelProviderItems(context),
      _ => const <Widget>[],
    };
    if (items.isEmpty) return items;
    if (_ownedProviders.length == 1) return items;
    return [_SectionHeader(label: _providerLabel(context, role)), ...items];
  }

  Widget _joinTile(BuildContext context, String role) {
    final l10n = context.l10n;
    return switch (role) {
      'technician' => _MoreTile(
        icon: Icons.engineering_outlined,
        label: l10n.applyAsTechnician,
        iconColor: AppColors.indigo,
        onTap: () => context.push(Routes.inserttechnicianprofile),
      ),
      'car-washer' => _MoreTile(
        icon: Icons.local_car_wash_outlined,
        label: l10n.registerCarWash,
        iconColor: AppColors.teal,
        onTap: () => context.push(Routes.create_profile_washer),
      ),
      'fuel-provider' => _MoreTile(
        icon: Icons.local_gas_station_outlined,
        label: l10n.registerAsFuelProvider,
        iconColor: AppColors.amber,
        onTap: () => context.push(Routes.provider_create_profile),
      ),
      'shop-owner' => _MoreTile(
        icon: Icons.store_outlined,
        label: l10n.openSparePartsShop,
        iconColor: AppColors.pink,
        onTap: () => context.push(Routes.ownerProfile),
      ),
      _ => const SizedBox.shrink(),
    };
  }

  List<Widget> _technicianItems(BuildContext context) {
    final l10n = context.l10n;
    return [
      _MoreTile(
        icon: Icons.assignment_outlined,
        label: l10n.maintenanceRequests,
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.orders),
      ),
      _MoreTile(
        icon: Icons.engineering_outlined,
        label: l10n.technicianProfile,
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.technicianProfileViewBody),
      ),
      _MoreTile(
        icon: Icons.build_circle_outlined,
        label: l10n.myJobs,
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.technician_jobs),
      ),
      _MoreTile(
        icon: Icons.emergency_outlined,
        label: l10n.availableSosRequests,
        iconColor: AppColors.red,
        onTap: () => context.push(
          Routes.technician_sos_requests,
          extra: SosRequestType.available,
        ),
      ),
      _MoreTile(
        icon: Icons.assignment_turned_in_outlined,
        label: l10n.acceptedSosRequests,
        iconColor: AppColors.red,
        onTap: () => context.push(
          Routes.technician_sos_requests,
          extra: SosRequestType.myRequests,
        ),
      ),
      _MoreTile(
        icon: Icons.bar_chart_outlined,
        label: l10n.myStatistics,
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.technician_statistics),
      ),
      _MoreTile(
        icon: Icons.receipt,
        label: l10n.myInvoices,
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.providerInvoices),
      ),
    ];
  }

  List<Widget> _carWasherItems(BuildContext context) {
    final l10n = context.l10n;
    return [
      _MoreTile(
        icon: Icons.local_car_wash_outlined,
        label: l10n.carWashProfile,
        iconColor: AppColors.carWashTeal,
        onTap: () => context.push(Routes.profile_washer),
      ),
      _MoreTile(
        icon: Icons.calendar_month_outlined,
        label: l10n.bookings,
        iconColor: AppColors.carWashTeal,
        onTap: () => context.push(Routes.washerBookings),
      ),
      _MoreTile(
        icon: Icons.bar_chart_outlined,
        label: l10n.statistics,
        iconColor: AppColors.carWashTeal,
        onTap: () => context.push(Routes.washer_statistics),
      ),
      _MoreTile(
        icon: Icons.receipt,
        label: l10n.myInvoices,
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.providerInvoices),
      ),
    ];
  }

  List<Widget> _fuelProviderItems(BuildContext context) {
    final l10n = context.l10n;
    return [
      _MoreTile(
        icon: Icons.local_gas_station_outlined,
        label: l10n.fuelProviderProfile,
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.provider_profile),
      ),
      _MoreTile(
        icon: Icons.receipt_long_outlined,
        label: l10n.fuelOrders,
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.provider_order),
      ),
      _MoreTile(
        icon: Icons.share_location_outlined,
        label: l10n.shareLocation,
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.share_location_fuel),
      ),
      if (showFuelProviderStatisticsTile(roles))
        _MoreTile(
          icon: Icons.bar_chart_outlined,
          label: l10n.myStatistics,
          iconColor: AppColors.primary,
          onTap: () => context.push(Routes.provider_statistics),
        ),
      _MoreTile(
        icon: Icons.receipt,
        label: l10n.myInvoices,
        iconColor: AppColors.primary,
        onTap: () => context.push(Routes.providerInvoices),
      ),
    ];
  }
}

enum _ShopAccessLevel { noShop, restricted, approved }

class _ShopOwnerSection extends StatelessWidget {
  const _ShopOwnerSection();

  Future<_ShopAccessLevel> _resolveAccess() async {
    final cubit = getIt<OwnerProfileCubit>();
    cubit.loadProfile();
    final state = await cubit.stream.firstWhere(
      (s) => s is OwnerProfileReady || s is OwnerProfileError,
    );
    await cubit.close();
    if (state is OwnerProfileReady) {
      final shop = state.shop;
      if (shop == null) return _ShopAccessLevel.noShop;
      return shop.status == 'approved'
          ? _ShopAccessLevel.approved
          : _ShopAccessLevel.restricted;
    }
    return _ShopAccessLevel.restricted;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FutureBuilder<_ShopAccessLevel>(
      future: _resolveAccess(),
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox.shrink();
        return switch (snap.data!) {
          _ShopAccessLevel.noShop => _MoreTile(
            icon: Icons.store_outlined,
            label: l10n.openSparePartsShop,
            iconColor: AppColors.pink,
            onTap: () => context.push(Routes.ownerProfile),
          ),
          _ShopAccessLevel.restricted => _MoreTile(
            icon: Icons.store_outlined,
            label: l10n.shopProfile,
            iconColor: AppColors.primary,
            onTap: () => context.push(Routes.ownerProfile),
          ),
          _ShopAccessLevel.approved => Column(
            children: [
              _MoreTile(
                icon: Icons.store_outlined,
                label: l10n.shopProfile,
                iconColor: AppColors.primary,
                onTap: () => context.push(Routes.ownerProfile),
              ),
              _MoreTile(
                icon: Icons.receipt_long_outlined,
                label: l10n.shopOrders,
                iconColor: AppColors.primary,
                onTap: () => context.push(Routes.ownerOrders),
              ),
              _MoreTile(
                icon: Icons.inventory_2_outlined,
                label: l10n.shopProducts,
                iconColor: AppColors.primary,
                onTap: () => context.push(Routes.ownerProducts),
              ),
              _MoreTile(
                icon: Icons.category_outlined,
                label: l10n.shopSpecializations,
                iconColor: AppColors.primary,
                onTap: () => context.push(Routes.ownerSpecializations),
              ),
              _MoreTile(
                icon: Icons.receipt,
                label: l10n.myInvoices,
                iconColor: AppColors.primary,
                onTap: () => context.push(Routes.providerInvoices),
              ),
            ],
          ),
        };
      },
    );
  }
}

class _RoleHeader extends StatelessWidget {
  const _RoleHeader({required this.roleLabel});

  final String roleLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              color: AppColors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: AppColors.white,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.optionsTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  roleLabel,
                  style: TextStyle(
                    color: AppColors.white,
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
          color: AppColors.textSecondary(context),
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
        color: AppColors.white,
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
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.textSecondary(
                    context,
                  ).withValues(alpha: 0.5),
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

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: () => confirmAndLogout(context),
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(9.r),
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: AppColors.red,
                    size: 21.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    strings.logout,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.red,
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
