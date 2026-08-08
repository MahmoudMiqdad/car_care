import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/widgets/app_navigation_drawer.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainAppShell extends StatefulWidget {
  const MainAppShell({
    super.key,
    required this.child,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // صفحات بدون BottomNav + Drawer (Full Screen)
  final List<String> fullScreenRoutes = [
    Routes.washerDetails,
    Routes.technician_location,
    Routes.technician_sos_requests,
    Routes.washerBookingsDetails,
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    // AppBar الأساسي فقط في Home
    final showShellAppBar = location == Routes.home;

    //  صفحات بدون BottomNav
    final hideShellBottomNav = fullScreenRoutes.contains(location);

    //  صفحات بدون Drawer
    final hideShellDrawer = fullScreenRoutes.contains(location);

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

        // Drawer
        endDrawer: hideShellDrawer ? null : const AppNavigationDrawer(),

        backgroundColor: context.colorScheme.surface,

        // AppBar فقط في Home
        appBar: showShellAppBar
            ? CustomAppBar(
                title: AppConstants.appName,
                showBackButton: false,
                useMainBranding: true,
                actionWidget: menuAction,
              )
            : null,

        //الصفحة
        body: widget.child,

        // Lets the body paint behind the floating pill bar/notch so the
        // page's own background shows through instead of a Scaffold-colored
        // strip appearing around/below it.
        extendBody: !hideShellBottomNav,

        // Bottom Navigation
        bottomNavigationBar: hideShellBottomNav
            ? null
            : widget.bottomNavigationBar,

        // AI Assistant floating action button
        floatingActionButton: hideShellBottomNav
            ? null
            : widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
      ),
    );
  }
}
