import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackTapped;
  final Widget? actionWidget;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackTapped,
    this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leadingWidth: showBackButton ? 100.w : 0,
        leading: showBackButton
            ? InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: onBackTapped ?? () => context.pop(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: actionWidget != null
            ? [
                Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: actionWidget,
                )
              ]
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64.h);
}