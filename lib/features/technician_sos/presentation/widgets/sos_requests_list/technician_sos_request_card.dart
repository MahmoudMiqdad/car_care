import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/media_url.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/sos_requests_list/technician_cancel_response_dialog.dart';
import 'package:car_care/features/technician_sos/domain/entities/technician_sos_entity.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/share_technician_location_cubit/share_technician_location_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_state.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/sos_requests_list/request_technician_detail_row.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/sos_requests_list/technician_sos_request_status_badge.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/technician_sos_map_widget.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TechnicianSosRequestCard extends StatelessWidget {
  const TechnicianSosRequestCard({
    super.key,
    required this.item,
    required this.showAcceptButton,
    this.onRefreshList,
  });

  final TechnicianSosEntity item;
  final bool showAcceptButton;

  final VoidCallback? onRefreshList;

  Future<void> _openMap(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<ShareTechnicianLocationSosCubit>()),
          BlocProvider.value(value: context.read<TechnicianSosCubit>()),
        ],
        child: _TechnicianNavigationSheet(
          sosId: item.id!,
          userLat: item.lat,
          userLng: item.lng,
        ),
      ),
    );
    onRefreshList?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final radius = AppConstants.maintenanceRequestCardRadius.r;

    return BlocListener<TechnicianSosCubit, TechnicianSosState>(
      listenWhen: (_, current) =>
          current is TechnicianRequestLoaded && current.request.id == item.id,
      listener: (context, state) {
        if (state is TechnicianRequestLoaded &&
            state.request.status == 'accepted') {
          _openMap(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.carWashTeal, width: 1),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withValues(alpha: 0.06),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  textDirection: Directionality.of(context),
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RequestTechnicianDetailRow(
                            label: l10n.sosRequestIdLabel,
                            leading: TechnicianSosRequestRowAssetIcon(
                              assetPath: AppAssets.editIcon,
                            ),
                            value: item.plateNumber.toString(),
                          ),
                          RequestTechnicianDetailRow(
                            label: l10n.sosRequestVehicleLabel,
                            leading: TechnicianSosRequestRowAssetIcon(
                              assetPath: AppAssets.sosRequestVehicleRowIcon,
                            ),
                            value: buildVehicleLabel(
                              brand: item.vehicleBrand,
                              model: item.vehicleModel,
                              year: item.vehicleYear,
                            ),
                          ),
                          RequestTechnicianDetailRow(
                            label: l10n.sosRequestShortDescriptionLabel,
                            leading: TechnicianSosRequestRowAssetIcon(
                              assetPath: AppAssets.technicianJobNotesIcon,
                            ),
                            multilineBelow: item.description,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(width: 1, color: AppColors.carWashTeal),
                    SizedBox(width: 12.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SosTechnicianRequestStatusBadge(
                          label: technicianSosRequestStatusLabel(
                            context,
                            item.status,
                            fallback: item.statusText,
                          ),
                          style: technicianSosRequestStatusBadgeStyleFor(
                            item.status,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                children: [
                  BlocBuilder<TechnicianSosCubit, TechnicianSosState>(
                    builder: (context, state) {
                      final isBusy =
                          state is TechnicianActionLoading &&
                          state.sosId == item.id;
                      return _StatusActions(
                        item: item,
                        showAcceptButton: showAcceptButton,
                        isBusy: isBusy,
                      );
                    },
                  ),

                  AppButton(
                    onPressed: () {
                      context.pushNamed(
                        'SosTechnicianDetailsPage',
                        pathParameters: {'id': item.id.toString()},
                      );
                    },
                    text: l10n.sosRequestViewDetails,
                    textColor: AppColors.white,
                    borderRadius: 24.r,
                    height: 50.h,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            Container(
              width: double.infinity,
              height: 35.h,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              color: AppColors.carWashTeal,
              child: Text(
                l10n.sosRequestCreatedAgo(item.createdAgo!),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusActions extends StatelessWidget {
  const _StatusActions({
    required this.item,
    required this.showAcceptButton,
    required this.isBusy,
  });

  final TechnicianSosEntity item;

  final bool showAcceptButton;
  final bool isBusy;

  Future<void> _cancelResponse(BuildContext context) async {
    final cubit = context.read<TechnicianSosCubit>();
    final reason = await showTechnicianCancelResponseDialog(context);
    if (reason == null) return;
    await cubit.cancelResponse(item.id!, reason);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = item.status;

    if (showAcceptButton) {
      if (status != 'open') return const SizedBox.shrink();
      return Column(
        children: [
          AppButton(
            onPressed: isBusy
                ? null
                : () => context.read<TechnicianSosCubit>().acceptRequest(
                    item.id!,
                  ),
            text: isBusy ? l10n.sosAcceptingInProgress : l10n.sosAcceptRequest,
            isOutline: true,
            backgroundColor: AppColors.carWashTeal,
            outlineSurfaceColor: context.colorScheme.surfaceContainer,
            textColor: AppColors.carWashTeal,
            borderRadius: 24.r,
            height: 50.h,
          ),
          SizedBox(height: 10.h),
        ],
      );
    }

    if (status != 'accepted' && status != 'in_progress') {
      return const SizedBox.shrink();
    }

    final isAccepted = status == 'accepted';

    return Column(
      children: [
        AppButton(
          onPressed: isBusy
              ? null
              : () => context.read<TechnicianSosCubit>().changeStatus(
                  item.id!,
                  isAccepted ? 'in_progress' : 'completed',
                ),
          text: isBusy
              ? l10n.sosProcessingInProgress
              : (isAccepted ? l10n.sosStartProgress : l10n.sosFinishRequest),
          isOutline: true,
          backgroundColor: AppColors.carWashTeal,
          outlineSurfaceColor: context.colorScheme.surfaceContainer,
          textColor: AppColors.carWashTeal,
          borderRadius: 24.r,
          height: 50.h,
        ),
        SizedBox(height: 10.h),
        AppButton(
          onPressed: isBusy ? null : () => _cancelResponse(context),
          text: l10n.sosCancelResponse,
          isOutline: true,
          backgroundColor: AppColors.red,
          outlineSurfaceColor: context.colorScheme.surfaceContainer,
          textColor: AppColors.red,
          borderRadius: 24.r,
          height: 50.h,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class _TechnicianNavigationSheet extends StatelessWidget {
  final int sosId;
  final double? userLat;
  final double? userLng;

  const _TechnicianNavigationSheet({
    required this.sosId,
    this.userLat,
    this.userLng,
  });

  void _showChangeStatusDialog(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: Directionality.of(context),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            l10n.sosChangeStatusTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                tileColor: AppColors.accent.withValues(alpha: 0.12),
                title: Text(l10n.sosInProgressStatus),
                leading: Icon(Icons.play_circle, color: AppColors.accent),
                onTap: () {
                  Navigator.pop(dialogContext);
                  context.read<TechnicianSosCubit>().changeStatus(
                    sosId,
                    'in_progress',
                  );
                },
              ),
              SizedBox(height: 8.h),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                tileColor: AppColors.green50,
                title: Text(l10n.sosCompletedStatus),
                leading: Icon(Icons.check_circle, color: AppColors.green),
                onTap: () {
                  Navigator.pop(dialogContext);
                  context.read<TechnicianSosCubit>().changeStatus(
                    sosId,
                    'completed',
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: context.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 12.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Icon(Icons.navigation, color: AppColors.carWashTeal),
                SizedBox(width: 8.w),
                Text(
                  l10n.sosNavigateToCustomer,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: BlocBuilder<TechnicianSosCubit, TechnicianSosState>(
              builder: (context, state) {
                final isLoading = state is TechnicianLoading;
                return AppButton(
                  onPressed: isLoading
                      ? null
                      : () => _showChangeStatusDialog(context),
                  text: isLoading
                      ? l10n.sosUpdatingInProgress
                      : l10n.sosChangeStatusTitle,
                  textColor: AppColors.white,
                  borderRadius: 14.r,
                  height: 46.h,
                );
              },
            ),
          ),

          Expanded(
            child: TechnicianMapWidget(
              sosId: sosId,
              userLat: userLat,
              userLng: userLng,
            ),
          ),
        ],
      ),
    );
  }
}
