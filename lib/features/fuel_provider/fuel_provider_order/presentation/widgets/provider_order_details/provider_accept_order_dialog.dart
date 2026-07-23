import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProviderAcceptOrderDialogResult {
  const ProviderAcceptOrderDialogResult({
    required this.minutes,
    required this.notes,
  });

  final String minutes;
  final String notes;
}

class ProviderAcceptOrderDialog extends StatefulWidget {
  const ProviderAcceptOrderDialog({
    super.key,
    required this.title,
    required this.durationLabel,
    required this.notesLabel,
    required this.confirmLabel,
    required this.cancelLabel,
  });

  final String title;
  final String durationLabel;
  final String notesLabel;
  final String confirmLabel;
  final String cancelLabel;

  @override
  State<ProviderAcceptOrderDialog> createState() =>
      _ProviderAcceptOrderDialogState();
}

class _ProviderAcceptOrderDialogState extends State<ProviderAcceptOrderDialog> {
  late final TextEditingController _minutesController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _minutesController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    Navigator.of(context).pop(
      ProviderAcceptOrderDialogResult(
        minutes: _minutesController.text.trim(),
        notes: _notesController.text.trim(),
      ),
    );
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14.r);

    return ClipRRect(
      borderRadius: radius,
      child: Material(
        color: AppColors.white,
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
                  _DialogField(
                    label: widget.durationLabel,
                    controller: _minutesController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  SizedBox(height: 14.h),
                  _DialogField(
                    label: widget.notesLabel,
                    controller: _notesController,
                    maxLines: 3,
                    minLines: 2,
                  ),
                ],
              ),
            ),
            Container(
              height: 48.h,
              color: AppColors.carWashTeal,
              child: Row(
                textDirection: TextDirection.rtl,
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
                      label: widget.cancelLabel,
                      onTap: _onCancel,
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

class _DialogField extends StatelessWidget {
  const _DialogField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int minLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: controller,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          minLines: minLines,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
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

Future<ProviderAcceptOrderDialogResult?> showProviderAcceptOrderDialog(
  BuildContext context,
) {
  final l10n = context.l10n;

  return showDialog<ProviderAcceptOrderDialogResult>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        child: ProviderAcceptOrderDialog(
          title: l10n.providerOrderDetailsEstimatedArrivalDialogTitle,
          durationLabel: l10n.providerOrderDetailsEnterDurationMinutes,
          notesLabel: l10n.providerOrderDetailsEnterAdditionalNotes,
          confirmLabel: l10n.confirm,
          cancelLabel: l10n.cancel,
        ),
      );
    },
  );
}
