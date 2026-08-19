// حقل ملاحظة العنوان (إلزامي) في شاشة Checkout — مع AnimatedContainer لتأثير Focus
//إلزامي بناء عالباك
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/l10n.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutAddressNoteField extends StatefulWidget {
  const CheckoutAddressNoteField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  State<CheckoutAddressNoteField> createState() =>
      _CheckoutAddressNoteFieldState();
}

class _CheckoutAddressNoteFieldState extends State<CheckoutAddressNoteField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.edit_note_outlined, color: AppColors.primary, size: 18.sp),
            SizedBox(width: 6.w),
            Text(
              l10n.addressNoteLabel,
              style: context.textTheme.labelLarge!.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '*',
              style:context.textTheme.labelSmall!.copyWith(
                color: AppColors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18), 
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            onChanged: (_) => widget.onChanged(),
            maxLines: 3,
            minLines: 2,
          
            decoration: InputDecoration(
              hintText: l10n.addressNoteHint, 
              hintStyle: context.textTheme.labelSmall!.copyWith(
                color: AppColors.textSecondary(context),
              ),
              filled: true,
              fillColor: AppColors.secondary,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.35), 
                  width: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
            ),
            style:context.textTheme.bodyMedium!.copyWith(
              color: AppColors.textPrimary(context),
            ),
          ),
        ),
      ],
    );
  }
}
