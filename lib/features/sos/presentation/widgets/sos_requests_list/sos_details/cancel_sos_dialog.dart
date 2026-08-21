import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';

class CancelSosDialog extends StatefulWidget {
  const CancelSosDialog({super.key});

  @override
  State<CancelSosDialog> createState() => _CancelSosDialogState();
}

class _CancelSosDialogState extends State<CancelSosDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.r),
            topRight: Radius.circular(14.r),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(
          l10n.cancelRequestButton,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.white, fontSize: 14.sp, fontWeight: FontWeight.w700),
        ),
      ),
      content: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.cancelSosQuestion,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: AppColors.black.withValues(alpha: 0.87),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: l10n.cancelSosHint,
                hintStyle: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary(context)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.all(10.w),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(
            l10n.backButton,
            style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14.sp),
          ),
        ),
        TextButton(
          onPressed: () {
            final reason = _controller.text.trim();
            Navigator.of(context).pop(reason.isEmpty ? null : reason);
          },
          child: Text(
            l10n.confirmCancellationButton,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
