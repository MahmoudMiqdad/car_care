// قسم الإجراءات المتاحة للمالك حسب حالة الطلب.
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/cubit/owner_order_details/owner_order_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerOrderActionsSection extends StatelessWidget {
  const OwnerOrderActionsSection({
    super.key,
    required this.status,
    required this.activeAction,
    required this.onAccept,
    required this.onReject,
    required this.onStartProcessing,
    required this.onStartDelivery,
    required this.onConfirmDelivered,
    required this.onShareLocation,
  });

  final String status;
  final OwnerOrderActionType? activeAction;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onStartProcessing;
  final VoidCallback onStartDelivery;
  final VoidCallback onConfirmDelivered;
  final VoidCallback onShareLocation;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      'pending' => _PendingActions(
          activeAction: activeAction,
          onAccept: onAccept,
          onReject: onReject,
        ),
      'accepted' => _ActionButton(
          label: 'بدء التجهيز',
          icon: Icons.inventory_2_outlined,
          color: AppColors.info,
          actionType: OwnerOrderActionType.startProcessing,
          activeAction: activeAction,
          onTap: onStartProcessing,
        ),
      'processing' => _ActionButton(
          label: 'بدء التوصيل',
          icon: Icons.local_shipping_outlined,
          color: AppColors.primary,
          actionType: OwnerOrderActionType.startDelivery,
          activeAction: activeAction,
          onTap: onStartDelivery,
        ),
      'out_for_delivery' => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onShareLocation,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                icon: Icon(Icons.location_on_outlined, size: 16.sp),
                label: Text(
                  'مشاركة الموقع',
                  style: AppTypography.labelSmall
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            _ActionButton(
              label: 'تأكيد التوصيل',
              icon: Icons.check_circle_outline,
              color: AppColors.success,
              actionType: OwnerOrderActionType.confirmDelivered,
              activeAction: activeAction,
              onTap: onConfirmDelivered,
            ),
          ],
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _PendingActions extends StatelessWidget {
  const _PendingActions({
    required this.activeAction,
    required this.onAccept,
    required this.onReject,
  });

  final OwnerOrderActionType? activeAction;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'قبول الطلب',
            icon: Icons.check_rounded,
            color: AppColors.success,
            actionType: OwnerOrderActionType.accept,
            activeAction: activeAction,
            onTap: onAccept,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _ActionButton(
            label: 'رفض الطلب',
            icon: Icons.close_rounded,
            color: AppColors.error,
            actionType: OwnerOrderActionType.reject,
            activeAction: activeAction,
            onTap: onReject,
            outlined: true,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.actionType,
    required this.activeAction,
    required this.onTap,
    this.outlined = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final OwnerOrderActionType actionType;
  final OwnerOrderActionType? activeAction;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final isSelf = activeAction == actionType;
    final isDisabled = activeAction != null && !isSelf;

    final content = isSelf
        ? SizedBox(
            width: 20.sp,
            height: 20.sp,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: outlined ? color : AppColors.white,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.r),
    );

    if (outlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: isDisabled ? null : onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: isDisabled ? AppColors.lightBorder : color),
            padding: EdgeInsets.symmetric(vertical: 12.h),
            shape: shape,
          ),
          child: content,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: color.withOpacity(0.4),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          elevation: 0,
          shape: shape,
        ),
        child: content,
      ),
    );
  }
}
