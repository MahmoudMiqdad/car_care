import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/home/presentation/widgets/ServicesGrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w, top: 16.h, bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _GreetingSection(),
          SizedBox(height: 16.h),
          const _ActiveOrderCard(),
          SizedBox(height: 24.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child:ServicesGrid(
  onItemPressed: (index) {
    if (index == 0) {
      context.go(Routes.my_vehicles_page);
    }
  },
),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Text(
          'Hello , Sami ...',
          style: context.textTheme.headlineMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            letterSpacing: 0.4,
            height: 1.25,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}

class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'الطلبات النشطة',
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 10.h),
          Container(height: 1, color: Colors.white),
          SizedBox(height: 10.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Image.asset(
                  color: Colors.white,
                 width: 65,
                  AppAssets.maintenanceIcon,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.build,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'صيانة دورية - قيد التنفيذ',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'تاريخ 2026/2/18',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_back_ios_new,
                size: 16.sp,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(height: 1, color: Colors.white),
        ],
      ),
    );
  }
}
