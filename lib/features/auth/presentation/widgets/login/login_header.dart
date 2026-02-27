import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginHeader extends StatelessWidget {
   LoginHeader({super.key});
  @override
  Widget build(BuildContext context) {
      final strings = context.l10n;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.ltr,
        children: [
          TextButton.icon(
            onPressed: () => context.canPop()
                ? context.pop()
                : context.go(Routes.splash),
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18.sp,
              color: AppColors.white,
            ),
            label: Text(
              strings.back,
              style: context.textTheme.titleMedium?.copyWith(
                
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                shadows: const [
                  Shadow(
                    blurRadius: 10,
                    offset: Offset(0, 2),
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

