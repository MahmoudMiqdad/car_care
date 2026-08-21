import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool?> showDeleteRequestDialog(BuildContext context) {
  final l10n = context.l10n;

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => Dialog(
      backgroundColor: AppColors.transparent, 
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Material(
          color: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                color: AppColors.red, 
                child: Text(
                  l10n.deleteRequestTitle, 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
                child: Column(
                  children: [
                    Icon(
                      Icons.delete_forever_outlined,
                      color: AppColors.red, 
                      size: 48.r,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      l10n.deleteRequestConfirmation, 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      l10n.cannotUndoActionWarning, 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary(context), 
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 48.h,
                color: AppColors.red, 
                child: Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: AppColors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(dialogContext).pop(true),
                          child: Center(
                            child: Text(
                              l10n.yesDeleteButton, 
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
                          onTap: () => Navigator.of(dialogContext).pop(false),
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
      ),
    ),
  );
}
