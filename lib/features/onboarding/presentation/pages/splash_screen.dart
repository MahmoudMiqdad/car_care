// splash_screen.dart

import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/routing/role_route_resolver.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 3000), () async {
      if (!mounted) return;

      final storage = getIt<SecureStorage>();
      final token = await storage.getToken();

      if (!mounted) return;

      if (token == null || token.isEmpty) {
        context.go(Routes.onboarding);
        return;
      }

      final primaryRole = await storage.getPrimaryRole();

      if (!mounted) return;

      context.go(RoleRouteResolver.resolve(primaryRole));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // الخلفية
          Image.asset(
          AppAssets.backgroung,
            fit: BoxFit.cover,
          ),

          // طبقة تعتيم خفيفة
          Container(
            color: Colors.black.withValues(alpha: 0.35),
          ),

          // المحتوى
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, _) {
                return FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppAssets.logoImg,
                            width: 260.w,
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'CarCare',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Your Complete Car Care Solution',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white.withValues(alpha: 0.85),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}