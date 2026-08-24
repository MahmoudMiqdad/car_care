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

  static const List<String> _rootTabRoutes = [
    Routes.home,
    Routes.notifications,
    Routes.create_sos,
    Routes.more,
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final isRootTab = _rootTabRoutes.contains(location);

    final showShellAppBar = location == Routes.home;
    final hideShellBottomNav = !isRootTab;
    final hideShellDrawer = !isRootTab;

    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final hideFabForKeyboard =
        location == Routes.create_sos && isKeyboardVisible;

    final menuAction = IconButton(
      onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
      icon: Icon(
        Icons.menu,
        color: context.colorScheme.onPrimary,
        size: AppConstants.homeAppBarMenuIconSize,
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: hideShellDrawer ? null : const AppNavigationDrawer(),
      backgroundColor: context.colorScheme.surface,
      appBar: showShellAppBar
          ? CustomAppBar(
              title: AppConstants.appName,
              showBackButton: false,
              useMainBranding: true,
              actionWidget: menuAction,
            )
          : null,
      body: widget.child,
      extendBody: !hideShellBottomNav,
      bottomNavigationBar: hideShellBottomNav
          ? null
          : widget.bottomNavigationBar,
      floatingActionButton: (hideShellBottomNav || hideFabForKeyboard)
          ? null
          : widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
    );
  }
}
