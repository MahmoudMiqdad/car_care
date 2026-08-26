import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelReasonDialog extends StatefulWidget {
  const CancelReasonDialog({
    super.key,
    required this.title,
    required this.question,
    required this.hint,
    required this.confirmLabel,
    required this.backLabel,
  });

  final String title;
  final String question;
  final String hint;
  final String confirmLabel;
  final String backLabel;

  @override
  State<CancelReasonDialog> createState() => _CancelReasonDialogState();
}

class _CancelReasonDialogState extends State<CancelReasonDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    Navigator.of(context).pop(_controller.text.trim());
  }

  void _onBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14.r);

    return ClipRRect(
      borderRadius: radius,
      child: Material(
        color: context.colorScheme.surfaceContainer,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              color: AppColors.carWashTeal,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.question,
                    textAlign: TextAlign.right,
                    textDirection: Directionality.of(context),
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _controller,
                    textDirection: Directionality.of(context),
                    textAlign: TextAlign.right,
                    maxLines: 5,
                    minLines: 4,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: context.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: context.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      filled: true,
                      fillColor: context.colorScheme.surfaceContainer,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: AppColors.carWashTeal,
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: AppColors.carWashTeal,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 48.h,
              color: AppColors.carWashTeal,
              child: Row(
                textDirection: Directionality.of(context),
                children: [
                  Expanded(
                    child: _FooterAction(
                      label: widget.confirmLabel,
                      onTap: _onConfirm,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: double.infinity,
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                  Expanded(
                    child: _FooterAction(
                      label: widget.backLabel,
                      onTap: _onBack,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterAction extends StatelessWidget {
  const _FooterAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

Future<String?> showCancelReasonDialog(
  BuildContext context, {
  String? title,
  String? question,
  String? hint,
  String? confirmLabel,
  String? backLabel,
}) {
  final l10n = context.l10n;

  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        child: CancelReasonDialog(
          title: title ?? l10n.cancelReasonDialogTitle,
          question: question ?? l10n.cancelReasonDialogQuestion,
          hint: hint ?? l10n.cancelReasonDialogHint,
          confirmLabel: confirmLabel ?? l10n.confirm,
          backLabel: backLabel ?? l10n.cancelReasonDialogBack,
        ),
      );
    },
  );
}
