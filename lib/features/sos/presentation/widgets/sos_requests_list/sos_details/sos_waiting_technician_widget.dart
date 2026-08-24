import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaitingTechnicianWidget extends StatefulWidget {
  const WaitingTechnicianWidget({super.key});

  @override
  State<WaitingTechnicianWidget> createState() =>
      _WaitingTechnicianWidgetState();
}

class _WaitingTechnicianWidgetState extends State<WaitingTechnicianWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale1, _scale2, _scale3;
  late Animation<double> _opacity1, _opacity2, _opacity3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _scale1 = Tween(begin: 0.9, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _scale2 = Tween(begin: 0.9, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );
    _scale3 = Tween(begin: 0.9, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _opacity1 = Tween(begin: 0.9, end: 0.15).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6)),
    );
    _opacity2 = Tween(begin: 0.9, end: 0.15).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8)),
    );
    _opacity3 = Tween(begin: 0.9, end: 0.15).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRing(
    double size,
    Color color,
    Animation<double> scale,
    Animation<double> opacity,
  ) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Transform.scale(
        scale: scale.value,
        child: Opacity(
          opacity: opacity.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Center(
      child: Container(
        margin: EdgeInsets.all(24.w),
        padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 28.w),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120.w,
              height: 120.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildRing(120.w, AppColors.accent, _scale1, _opacity1),
                  _buildRing(90.w, AppColors.accent, _scale2, _opacity2),
                  _buildRing(60.w, AppColors.accent, _scale3, _opacity3),
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent,
                    ),
                    child: Icon(
                      Icons.build_rounded,
                      color: colorScheme.onPrimary,
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              l10n.searchingForTechnicianTitle,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              l10n.searchingForTechnicianSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary(context),
                height: 1.6,
              ),
            ),
            SizedBox(height: 20.h),
            _DotsIndicator(),
          ],
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatefulWidget {
  @override
  State<_DotsIndicator> createState() => _DotsIndicatorState();
}

class _DotsIndicatorState extends State<_DotsIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Animation<double> _anim(double start) => Tween(begin: 0.0, end: -6.0).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: Interval(start, start + 0.4, curve: Curves.easeInOut),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [0.0, 0.15, 0.30].map((d) {
          final anim = _anim(d);
          return Transform.translate(
            offset: Offset(0, anim.value),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
