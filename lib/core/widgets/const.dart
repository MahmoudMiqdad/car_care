import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_navigation_drawer.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MainAppShell extends StatefulWidget {
  const MainAppShell({
    super.key,
    required this.child,
    this.bottomNavigationBar,
  });

  final Widget child;
  final Widget? bottomNavigationBar;

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final isProfile = location == Routes.profile;
    final hideShellChrome = location == Routes.all_requests;

    final menuAction = IconButton(
      onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
      icon: Icon(
        Icons.menu,
        color: Colors.white,
        size: AppConstants.homeAppBarMenuIconSize,
      ),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: hideShellChrome ? null : const AppNavigationDrawer(),
        backgroundColor: context.colorScheme.surface,
        appBar: hideShellChrome
            ? null
            : (isProfile
                ? CustomAppBar(
                    title: context.l10n.profile,
                    showBackButton: true,
                    useMainBranding: false,
                    onBackTapped: () => context.go(Routes.home),
                    actionWidget: menuAction,
                  )
                : CustomAppBar(
                    title: AppConstants.appName,
                    showBackButton: false,
                    useMainBranding: true,
                    actionWidget: menuAction,
                  )),
        body: widget.child,
        bottomNavigationBar: widget.bottomNavigationBar,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackTapped;
  final Widget? actionWidget;
  final Widget? titleWidget;
  final Widget? leadingWidget;

  /// When true, shows main branding (centered logo; RTL-friendly).
  final bool useMainBranding;

  final double? toolbarHeight;
  final double elevation;

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
      backgroundColor: AppColors.primary,
      elevation: elevation,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: leadingWidget != null
          ? 60.w
          : (showBackButton ? 100.w : 0),
      leading: leadingWidget ??
          (showBackButton
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
              : null),
      title: titleWidget ??
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
      return Directionality(
        textDirection: TextDirection.ltr,
        child: appBar,
      );
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
          width: MediaQuery.sizeOf(context).width *
              AppConstants.homeAppBarLogoWidthFraction,
          height: AppConstants.homeAppBarLogoMaxHeight.h,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Text(
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
