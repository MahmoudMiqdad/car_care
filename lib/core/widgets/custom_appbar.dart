
import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackTapped;
  final Widget? actionWidget;
  final Widget? titleWidget;
  final Widget? leadingWidget;

  final bool useMainBranding;
  final double? toolbarHeight;
  final double elevation;

  final Color? backgroundColor;

  /// Where the default back action navigates when there is no route to pop
  /// (first route in stack via go/redirect/deep link). Ignored when
  /// [onBackTapped] is provided.
  final String fallbackRoute;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackTapped,
    this.actionWidget,
    this.titleWidget,
    this.leadingWidget,
    this.useMainBranding = false,
    this.toolbarHeight,
    this.elevation = 0,
    this.backgroundColor,
    this.fallbackRoute = Routes.home,
  });

  double get _barHeight {
    if (useMainBranding) return AppConstants.homeAppBarHeight.h;
    if (toolbarHeight != null) return toolbarHeight!.h;
    return 64.h;
  }

  @override
  Size get preferredSize => Size.fromHeight(_barHeight);

  @override
  Widget build(BuildContext context) {
    if (useMainBranding) {
      return _buildMainBrandingAppBar(context);
    }

    final appBar = AppBar(
      toolbarHeight: toolbarHeight?.h,
      backgroundColor: backgroundColor ?? AppColors.primary,
      elevation: elevation,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: leadingWidget != null ? 60.w : (showBackButton ? 100.w : 0),
      leading:
          leadingWidget ??
          (showBackButton
              ? InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: onBackTapped ?? () => context.safePopOrGo(fallbackRoute),
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
                          context.l10n.back,
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
              : null),
      title:
          titleWidget ??
          Text(
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
              ),
            ]
          : null,
    );

    if (showBackButton && leadingWidget == null) {
      return Directionality(textDirection: TextDirection.ltr, child: appBar);
    }
    return appBar;
  }

  PreferredSizeWidget _buildMainBrandingAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: AppConstants.homeAppBarHeight.h,
      backgroundColor: AppColors.primary,
      elevation: AppConstants.homeAppBarElevation,
      automaticallyImplyLeading: false,
      leadingWidth: 0,
      centerTitle: true,
      titleSpacing: 0,
      title: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: AppConstants.homeAppBarLogoMaxHeight.h,
          maxWidth: AppConstants.homeAppBarLogoMaxWidth.w,
        ),
        child: Image.asset(
          AppAssets.homeAppBarLogo,
          width:
              MediaQuery.sizeOf(context).width *
              AppConstants.homeAppBarLogoWidthFraction,
          height: AppConstants.homeAppBarLogoMaxHeight.h,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      actions: [
        if (actionWidget != null)
          Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: actionWidget,
          ),
      ],
    );
  }
}
