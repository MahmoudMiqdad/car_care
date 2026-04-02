import 'package:car_care/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
   return Center(
              child: Lottie.asset(
                AppAssets.loadingImage,
                width: 500.w,
                height: 500.h,
                fit: BoxFit.contain,
              ),
            );
  }
}