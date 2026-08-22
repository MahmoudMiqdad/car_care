import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart'; 

class AiAssistantButton extends StatelessWidget {
  const AiAssistantButton({super.key, this.size = 64}); 

  final double size;
  static const Color _amber = Color(0xFFF6C177);
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
              colors: [AppColors.accent, _amber],
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
              onTap: () {
                context.pushNamed('/assistant_chat'); 
              },
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
