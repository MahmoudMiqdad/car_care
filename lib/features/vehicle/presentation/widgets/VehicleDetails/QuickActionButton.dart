// ignore_for_file: deprecated_member_use, file_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickActionButton extends StatelessWidget {
  final String label;
  final String? iconPath;
  final IconData? iconData;
  final Color color;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.label,
    this.iconPath,
    this.iconData,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12.r),
              splashColor: color.withOpacity(0.15),
              highlightColor: color.withOpacity(0.05),
              child: Center(
                child: iconPath != null
                    ? Image.asset(
                        iconPath!,
                        width: 35.w,
                        height: 35.w,
                        color: color,
                        fit: BoxFit.contain,
                      )
                    : Icon(
                        iconData,
                        color: color,
                        size: 35.sp,
                      ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}