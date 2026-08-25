import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class _OnboardingData {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;

  const _OnboardingData({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next(int pagesLength) {
    if (_currentIndex < pagesLength - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(Routes.login);
    }
  }

  void _skip() => context.go(Routes.login);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final pages = [
      _OnboardingData(
        icon: Icons.build_circle_outlined,
        iconColor: const Color(0xFF007A92),
        bgColor: const Color(0xFFE8F7FA),
        title: l10n.onboardingTitleMaintenance,
        subtitle: l10n.onboardingSubtitleMaintenance,
      ),
      _OnboardingData(
        icon: Icons.emergency_outlined,
        iconColor: const Color(0xFFD84315),
        bgColor: const Color(0xFFFFF3E0),
        title: l10n.onboardingTitleEmergency,
        subtitle: l10n.onboardingSubtitleEmergency,
      ),
      _OnboardingData(
        icon: Icons.local_gas_station_outlined,
        iconColor: const Color(0xFF2E7D32),
        bgColor: const Color(0xFFE8F5E9),
        title: l10n.onboardingTitleAllInOne,
        subtitle: l10n.onboardingSubtitleAllInOne,
      ),
    ];

    return Scaffold(
      body: ImageBackground(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    l10n.skip,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemBuilder: (_, i) => _OnboardingSlide(data: pages[i]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: _currentIndex == i ? 24.w : 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: _currentIndex == i
                          ? AppColors.carWashTeal
                          : AppColors.border(context),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AppButton(
                  onPressed: () => _next(pages.length),
                  text: _currentIndex == pages.length - 1
                      ? l10n.getStarted
                      : l10n.next,
                  height: 54.h,
                  borderRadius: 14.r,
                  fontSize: 17.sp,
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.data});

  final _OnboardingData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180.r,
            height: 180.r,
            decoration: BoxDecoration(
              color: data.bgColor.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: data.iconColor.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(data.icon, size: 90.r, color: data.iconColor),
          ),
          SizedBox(height: 48.h),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: context.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.textPrimary(context),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}