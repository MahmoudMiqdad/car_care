import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelOrderBottomSheet extends StatefulWidget {
  const CancelOrderBottomSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const CancelOrderBottomSheet(),
      ),
    );
  }

  @override
  State<CancelOrderBottomSheet> createState() => _CancelOrderBottomSheetState();
}

class _CancelOrderBottomSheetState extends State<CancelOrderBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  bool get _canConfirm => _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border(context),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(
                Icons.cancel_outlined,
                color: colorScheme.error,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                l10n.cancelRequestButton,
                style: context.textTheme.labelLarge!.copyWith(
                  color: AppColors.textPrimary(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            l10n.cancellationReason,
            style: context.textTheme.labelSmall!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _controller,
            onChanged: (_) => setState(() {}),
            maxLines: 3,
            minLines: 2,
            autofocus: true,
            decoration: InputDecoration(
              hintText: l10n.cancelOrderFormHint,
              hintStyle: context.textTheme.labelSmall!.copyWith(
                color: AppColors.textSecondary(context),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
            ),
            style: context.textTheme.bodyMedium!.copyWith(
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, null),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary(context),
                    side: BorderSide(color: AppColors.border(context)),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    l10n.no,
                    style: context.textTheme.labelLarge!.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _canConfirm
                      ? () => Navigator.pop(context, _controller.text.trim())
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    disabledBackgroundColor: AppColors.border(context),
                  ),
                  child: Text(
                    l10n.confirmCancellationButton,
                    style: context.textTheme.labelLarge!.copyWith(
                      color: colorScheme.onError,
                    ),
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
