import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInfoRow extends StatelessWidget {
  const AppInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.leading,
    this.labelFontSize = 14,
    this.valueFontSize = 14,
  });

  final String label;
  final String value;
  final Widget? leading;
  final double labelFontSize;
  final double valueFontSize;

  @override
  Widget build(BuildContext context) {
    final currentLang = Localizations.localeOf(context).languageCode;
    final fontFamily = AppTypography.getFontFamily(currentLang);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        // start بدل center: لو label طويل وعمل سطرين، الـ leading بيضل فوق
        // مش بينزل بالنص، وهاد كمان بيمنع شكل "متكسر" بصريًا.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: 8.w),
          ],

          // 🔑 الحل: label و value داخل نفس الـ Text.rich جوا Expanded وحدة.
          // هيك بيلتزموا بعرض واحد وبيلفوا سطر تاني مع بعض بشكل طبيعي،
          // بدل ما يكون label بلا حدود ويعمل overflow خارج الـ Row.
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      fontSize: labelFontSize.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: fontFamily,
                      color: AppColors.textSecondary(context),
                      height: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: valueFontSize.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: fontFamily,
                      color: AppColors.textPrimary(context),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
              softWrap: true,
              overflow: TextOverflow.clip, // ما بيقص الكلمة، بيلف سطر جديد بدل ما "يتفكك"
            ),
          ),
        ],
      ),
    );
  }
}