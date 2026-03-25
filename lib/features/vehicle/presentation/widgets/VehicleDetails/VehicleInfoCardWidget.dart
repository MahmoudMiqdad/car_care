// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleInfoCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final Widget icon;

  const VehicleInfoCardWidget({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14.sp, color: Colors.black54, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon,
              Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}