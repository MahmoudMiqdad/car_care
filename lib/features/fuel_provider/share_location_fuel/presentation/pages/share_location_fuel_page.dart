import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Sharing a location always belongs to a specific fuel order, so this
/// screen never starts sharing on its own. Opened without an order it
/// explains where sharing actually happens:
/// مزود الوقود → طلباتي → تفاصيل الطلب → مشاركة الموقع
class ShareLocationFuelPage extends StatelessWidget {
  const ShareLocationFuelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(
          title: 'مشاركة الموقع',
          showBackButton: true,
          backgroundColor: AppColors.carWashTeal,
          onBackTapped: () => context.safePopOrGo(Routes.more),
        ),
        body: ImageBackground(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.share_location_outlined,
                      size: 64.sp,
                      color: AppColors.carWashTeal,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'اختر طلب وقود قيد التنفيذ من طلباتي لمشاركة موقعك',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go(Routes.provider_order),
                        icon: const Icon(Icons.receipt_long_outlined),
                        label: const Text('الذهاب إلى طلباتي'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.carWashTeal,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
