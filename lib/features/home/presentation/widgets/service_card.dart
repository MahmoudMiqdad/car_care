import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/features/home/presentation/widgets/ServicesGrid.dart';
import 'package:car_care/features/home/presentation/widgets/service_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, 
    required this.item,
    this.onPressed,
  });

  final ServiceItemData item;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        splashColor: scheme.primary.withValues(alpha: 0.08),
        highlightColor: scheme.primary.withValues(alpha: 0.05),
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color.fromARGB(255, 172, 164, 164).withValues(alpha: 0.55),
                scheme.surface.withValues(alpha: 0.92),
                Color.lerp(scheme.surface, scheme.primary, 0.06)!,
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
            border: Border.all(
              color: scheme.primary.withValues(alpha: 0.11),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.07),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ServiceImage(
                  path: item.imagePath,
                  width: 58.w,
                  height: 46.h,
                ),
                SizedBox(height: 10.h),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                    height: 1.25,
                    letterSpacing: 0.15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}