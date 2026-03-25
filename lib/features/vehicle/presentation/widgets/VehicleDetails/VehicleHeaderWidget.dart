// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleHeaderWidget extends StatelessWidget {
  const VehicleHeaderWidget({
    super.key,
    required this.imageUrl,
    required this.vehicleName,
    required this.ownerName,
  });

  final String? imageUrl;
  final String vehicleName;
  final String ownerName;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3.w),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
            ),
            child: ClipOval(
              child: hasImage
                  ? Image.network(
                      imageUrl!,
                      width: 140.w,
                      height: 140.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/car.png',
                        width: 140.w,
                        height: 140.w,
                        fit: BoxFit.cover,
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return SizedBox(
                          width: 140.w,
                          height: 140.w,
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/car.png',
                      width: 140.w,
                      height: 140.w,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            vehicleName,
            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w900, color: Colors.black),
          ),
          Text(
            'المالك : $ownerName',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}