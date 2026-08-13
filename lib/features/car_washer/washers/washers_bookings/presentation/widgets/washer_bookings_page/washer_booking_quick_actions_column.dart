import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<String> washerBookingVisibleActionKeys({
  required bool showAcceptReject,
  required bool showStartComplete,
  required bool showCompleteOnly,
}) {
  if (showAcceptReject) return const ['accept', 'reject'];
  if (showStartComplete) return const ['start'];
  if (showCompleteOnly) return const ['complete'];
  return const [];
}

class WasherBookingQuickActionsColumn extends StatelessWidget {
  const WasherBookingQuickActionsColumn({
    super.key,
    required this.showAcceptReject,
    required this.showStartComplete,
    required this.showCompleteOnly,
    required this.rejectMode,
    required this.rejectController,
    required this.onAccept,
    required this.onRejectTap,
    required this.onRejectSubmit,
    required this.onStartExecution,
    required this.onComplete,
    this.busy = false,
  });

  final bool showAcceptReject;
  final bool showStartComplete;
  final bool showCompleteOnly;

  final bool rejectMode;
  final TextEditingController rejectController;

  final VoidCallback onAccept;
  final VoidCallback onRejectTap;
  final VoidCallback onRejectSubmit;

  final VoidCallback onStartExecution;
  final VoidCallback onComplete;

  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (busy && (showAcceptReject || showStartComplete || showCompleteOnly)) {
      return SizedBox(
        width: 90.w,
        child: Column(
          children: [
            SizedBox(height: 40.h),
            SizedBox(
              width: 18.w,
              height: 18.w,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      );
    }

    if (showAcceptReject && rejectMode) {
      return SizedBox(
        width: 120.w,
        child: Column(
          children: [
            SizedBox(height: 40.h),
            TextField(
              controller: rejectController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'سبب الرفض',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            _ActionBtn(label: 'إرسال', onPressed: onRejectSubmit, filled: true),
          ],
        ),
      );
    }

    final visibleKeys = washerBookingVisibleActionKeys(
      showAcceptReject: showAcceptReject,
      showStartComplete: showStartComplete,
      showCompleteOnly: showCompleteOnly,
    );

    if (visibleKeys.isEmpty) return const SizedBox.shrink();

    final buttonsByKey = <String, Widget>{
      'accept': _ActionBtn(
        label: l10n.washerBookingAccept,
        onPressed: onAccept,
      ),
      'reject': _ActionBtn(
        label: l10n.washerBookingReject,
        onPressed: onRejectTap,
      ),
      'start': _ActionBtn(
        label: l10n.washerBookingStartExecution,
        onPressed: onStartExecution,
      ),
      'complete': _ActionBtn(
        label: l10n.washerBookingCompleted,
        onPressed: onComplete,
      ),
    };

    return Column(
      children: [
        SizedBox(height: 40.h),
        for (final key in visibleKeys) buttonsByKey[key]!,
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.label,
    required this.onPressed,
    this.filled = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: SizedBox(
        width: 90.w,
        height: 28.h,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary, width: 1),
            padding: EdgeInsets.zero,
            backgroundColor: filled ? AppColors.primary : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: filled ? Colors.white : AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
