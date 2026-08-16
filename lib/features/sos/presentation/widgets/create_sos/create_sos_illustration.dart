import 'package:car_care/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateSosIllustration extends StatelessWidget {
  const CreateSosIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
        child: Image.asset(
          AppAssets.sosCreateIcon,
          height: 96.h,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => Icon(
            Icons.car_crash_outlined,
            size: 72.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
