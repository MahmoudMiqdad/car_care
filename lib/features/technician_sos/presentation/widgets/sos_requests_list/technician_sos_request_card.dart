import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/constants/app_assets.dart';
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

  /// Reloads the list once the navigation sheet closes, so an accepted
  /// request leaves the "available" list.
  final VoidCallback? onRefreshList;

  Future<void> _openMap(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<ShareTechnicianLocationSosCubit>(),
          ),
          BlocProvider.value(
            value: context.read<TechnicianSosCubit>(),
          ),
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

    // Errors and cancel messages are handled once on the list page, so this
    // listener only reacts to this card's own request being accepted.
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
          color: AppColors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.carWashTeal, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── بيانات الطلب ───────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  textDirection: TextDirection.rtl,
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
                    // Real backend status only — no static three-state list.
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SosTechnicianRequestStatusBadge(
                          label: item.statusText?.trim().isNotEmpty == true
                              ? item.statusText!
                              : '-',
                          style: item.status == 'completed'
                              ? TechnicianSosRequestStatusBadgeStyle
                                  .outlineOnWhite
                              : TechnicianSosRequestStatusBadgeStyle
                                  .softSuccess,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ─── الأزرار ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                children: [
                  // الأزرار حسب الحالة الحقيقية القادمة من الباك اند
                  BlocBuilder<TechnicianSosCubit, TechnicianSosState>(
                    builder: (context, state) {
                      final isBusy = state is TechnicianActionLoading &&
                          state.sosId == item.id;
                      return _StatusActions(
                        item: item,
                        showAcceptButton: showAcceptButton,
                        isBusy: isBusy,
                      );
                    },
                  ),

                  // زر التفاصيل
                  AppButton(
                    onPressed: () {
                      context.pushNamed(
                        'SosTechnicianDetailsPage',
                        pathParameters: {'id': item.id.toString()},
                      );
                    },
                    text: l10n.sosRequestViewDetails,
                    backgroundColor: AppColors.accent,
                    textColor: AppColors.white,
                    borderRadius: 24.r,
                    height: 50.h,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // ─── شريط الوقت ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              height: 35.h,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              color: AppColors.carWashTeal,
              child: Text(
                'created Ago ${item.createdAgo!}',
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

// ─── أزرار الإجراءات حسب حالة الطلب ─────────────────────────────────────────
class _StatusActions extends StatelessWidget {
  const _StatusActions({
    required this.item,
    required this.showAcceptButton,
    required this.isBusy,
  });

  final TechnicianSosEntity item;

  /// True on the "available" list, where the only action is accepting.
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
    final status = item.status;

    // open -> accept only (available list)
    if (showAcceptButton) {
      if (status != 'open') return const SizedBox.shrink();
      return Column(
        children: [
          AppButton(
            onPressed: isBusy
                ? null
                : () =>
                    context.read<TechnicianSosCubit>().acceptRequest(item.id!),
            text: isBusy ? 'جاري القبول...' : 'قبول الطلب',
            isOutline: true,
            backgroundColor: AppColors.carWashTeal,
            outlineSurfaceColor: AppColors.white,
            textColor: AppColors.carWashTeal,
            borderRadius: 24.r,
            height: 50.h,
          ),
          SizedBox(height: 10.h),
        ],
      );
    }

    // completed / cancelled / anything else -> no actions at all
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
              ? 'جاري التنفيذ...'
              : (isAccepted ? 'بدء التنفيذ' : 'إنهاء الطلب'),
          isOutline: true,
          backgroundColor: AppColors.carWashTeal,
          outlineSurfaceColor: AppColors.white,
          textColor: AppColors.carWashTeal,
          borderRadius: 24.r,
          height: 50.h,
        ),
        SizedBox(height: 10.h),
        AppButton(
          onPressed: isBusy ? null : () => _cancelResponse(context),
          text: 'إلغاء الاستجابة',
          isOutline: true,
          backgroundColor: AppColors.error,
          outlineSurfaceColor: AppColors.white,
          textColor: AppColors.error,
          borderRadius: 24.r,
          height: 50.h,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

// ─── Navigation Sheet (الخريطة مع زر تغيير الحالة) ───────────────────────────
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
    showDialog(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: const Text(
            'تغيير حالة الطلب',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ─── قيد التنفيذ ──────────────────────────────────────
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                tileColor: Colors.orange.shade50,
                title: const Text('قيد التنفيذ'),
                leading:
                    const Icon(Icons.play_circle, color: Colors.orange),
                onTap: () {
                  Navigator.pop(dialogContext);
                  context
                      .read<TechnicianSosCubit>()
                      .changeStatus(sosId, 'in_progress');
                },
              ),
              SizedBox(height: 8.h),
              // ─── منتهي ───────────────────────────────────────────
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                tileColor: Colors.green.shade50,
                title: const Text('منتهي'),
                leading:
                    const Icon(Icons.check_circle, color: Colors.green),
                onTap: () {
                  Navigator.pop(dialogContext);
                  // backend value is `completed`, not `finished`
                  context
                      .read<TechnicianSosCubit>()
                      .changeStatus(sosId, 'completed');
                  Navigator.pop(context); // اغلق الخريطة بعد الإنهاء
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 12.h),

          // ─── Header ────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Icon(Icons.navigation, color: AppColors.carWashTeal),
                SizedBox(width: 8.w),
                Text(
                  'التوجه للعميل',
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

          // ─── زر تغيير الحالة ───────────────────────────────────────
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: BlocBuilder<TechnicianSosCubit, TechnicianSosState>(
              builder: (context, state) {
                final isLoading = state is TechnicianLoading;
                return AppButton(
                  onPressed: isLoading
                      ? null
                      : () => _showChangeStatusDialog(context),
                  text: isLoading ? 'جاري التحديث...' : 'تغيير حالة الطلب',
                  backgroundColor: AppColors.accent,
                  textColor: AppColors.white,
                  borderRadius: 14.r,
                  height: 46.h,
                );
              },
            ),
          ),

          // ─── الخريطة ───────────────────────────────────────────────
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