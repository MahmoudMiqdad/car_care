import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/home/presentation/widgets/ServicesGrid.dart';
import 'package:car_care/features/home/presentation/widgets/home_palette.dart';
import 'package:car_care/features/home/presentation/widgets/service_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.item, this.onPressed});

  final ServiceItemData item;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final borderRadius = BorderRadius.circular(10.r); // قمنا بتوحيد الرياديوس هنا منعا للتكرار
    return Material(
      color: AppColors.transparent,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
 borderRadius: borderRadius,  
       splashColor: HomePalette.primaryTeal.withValues(alpha: 0.08),
        highlightColor: HomePalette.primaryTeal.withValues(alpha: 0.05),
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: HomePalette.cardGradient,
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: ServiceImage(
                        path: item.imagePath,
                        width: 80.w,
                        height: 80.h,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: HomePalette.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                        height: 1.25,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: HomePalette.accentOrange,
                    size: 18.sp,
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