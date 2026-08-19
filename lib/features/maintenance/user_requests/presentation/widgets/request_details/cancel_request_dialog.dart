

import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelRequestDialog extends StatefulWidget {
  const CancelRequestDialog({super.key});

  @override
  State<CancelRequestDialog> createState() => _CancelRequestDialogState();
}

class _CancelRequestDialogState extends State<CancelRequestDialog> {
  late final TextEditingController _reasonController;
  String? _error;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
   
      setState(() => _error = context.l10n.pleaseEnterCancellationReason);
      return;
    }
    Navigator.of(context).pop(reason);
  }

  void _onCancel() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; 

    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: Material(
        color: AppColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              color: AppColors.reservationConfirmOrange,
              child: Text(
                l10n.cancelRequestButton, 
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
                    l10n.cancellationReason, 
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: _reasonController,
                    maxLines: 3,
                    minLines: 2,
                    onChanged: (_) {
                      if (_error != null) setState(() => _error = null);
                    },
                    style: TextStyle(fontSize: 15.sp, color: AppColors.black),
                    decoration: InputDecoration(
                      errorText: _error,
                      hintText: l10n.bookingsCancelReasonHint, 
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: AppColors.reservationConfirmOrange,
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: AppColors.reservationConfirmOrange,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              height: 48.h,
              color: AppColors.reservationConfirmOrange,
              child: Row(
                children: [ 
                  Expanded(
                    child: Material(
                      color: AppColors.transparent, 
                      child: InkWell(
                        onTap: _onConfirm,
                        child: Center(
                          child: Text(
                            l10n.confirmCancellationButton, 
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: double.infinity,
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                  Expanded(
                    child: Material(
                      color: AppColors.transparent, 
                      child: InkWell(
                        onTap: _onCancel,
                        child: Center(
                          child: Text(
                            l10n.backButton,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
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

Future<String?> showCancelRequestDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      backgroundColor: AppColors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: const CancelRequestDialog(),
    ),
  );
}
