import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherBookingsDetailsSection extends StatelessWidget {
  const WasherBookingsDetailsSection({
    super.key,
    required this.title,
    required this.lines,
    this.textAlign,
    this.contentFontWeight = FontWeight.w700,
  });

  final String title;
  final List<String> lines;
  final TextAlign? textAlign;
  final FontWeight contentFontWeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.sectionTitle(context, title, fontWeight: FontWeight.w800),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lines
                .map(
                  (line) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Text(
                      line,
                      textAlign: textAlign ?? TextAlign.start,
                      style: TextStyle(
                        color: context.colorScheme.onSurface,
                        fontWeight: contentFontWeight,
                        height: 1.35,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
