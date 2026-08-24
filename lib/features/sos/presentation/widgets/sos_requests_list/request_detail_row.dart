import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestDetailRow extends StatelessWidget {
  const RequestDetailRow({
    super.key,
    required this.label,
    required this.leading,
    this.value,
    this.multilineBelow,
  }) : assert(
         value != null || multilineBelow != null,
         'Provide value and/or multilineBelow',
       );

  final String label;
  final Widget leading;
  final String? value;
  final String? multilineBelow;

  @override
  Widget build(BuildContext context) {
    final onSurface = context.colorScheme.onSurface;
    final labelStyle = TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w800,
      color: onSurface,
    );
    final valueStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: onSurface,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        SizedBox(
          width: 22.w,
          height: 22.w,
          child: Center(child: leading),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: multilineBelow != null && (value == null || value!.isEmpty)
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '$label: ', style: labelStyle),
                      TextSpan(text: multilineBelow!, style: valueStyle),
                    ],
                  ),
                  textDirection: TextDirection.rtl,
                  softWrap: true,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: valueStyle,
                        children: [
                          TextSpan(text: '$label: ', style: labelStyle),
                          if (value != null && value!.isNotEmpty)
                            TextSpan(text: value, style: valueStyle),
                        ],
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    if (multilineBelow != null &&
                        value != null &&
                        value!.isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      Text(
                        multilineBelow!,
                        style: valueStyle,
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class SosRequestRowAssetIcon extends StatelessWidget {
  const SosRequestRowAssetIcon({super.key, required this.assetPath, this.size});

  final String assetPath;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final s = size ?? 20.w;
    return Image.asset(
      assetPath,
      width: s,
      height: s,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => Icon(
        Icons.image_not_supported_outlined,
        size: s,
        color: AppColors.carWashTeal,
      ),
    );
  }
}
