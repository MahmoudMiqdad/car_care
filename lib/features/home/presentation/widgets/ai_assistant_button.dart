import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centered, center-docked AI assistant action for [HomeBottomNavBar]'s
/// notch. Purely visual until [onPressed] is wired up — never navigates or
/// shows placeholder feedback on its own.
class AiAssistantButton extends StatelessWidget {
  const AiAssistantButton({super.key, this.onPressed, this.size = 64});

  final VoidCallback? onPressed;
  final double size;

  static const Color _amber = Color(0xFFF6C177);

  // Not sourced from l10n: this batch is scoped to geometry only and must
  // not touch the ARB files. Wire this to a localized string when the chat
  // feature (and its l10n keys) is implemented.
  static const String _label = 'المساعد الذكي';

  @override
  Widget build(BuildContext context) {
    const label = _label;
    final diameter = size.r;

    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        label: label,
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.orange, _amber],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              // Chat bubble (outline, so it frames rather than hides the car
              // icon) + a small car-front glyph + a spark accent — reads as
              // "AI chat about your car" without any text in the button.
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Colors.white,
                    size: diameter * 0.62,
                  ),
                  Align(
                    alignment: const Alignment(0, -0.12),
                    child: Icon(
                      Icons.directions_car_rounded,
                      color: Colors.white,
                      size: diameter * 0.30,
                    ),
                  ),
                  Positioned(
                    right: diameter * 0.14,
                    top: diameter * 0.12,
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: diameter * 0.24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
