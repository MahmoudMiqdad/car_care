import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData createTheme({
    required bool isDark,
    required String languageCode,
  }) {
    final fontFamily = AppTypography.getFontFamily(languageCode);
    final colorScheme = isDark ? _darkScheme : _lightScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      fontFamily: fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      // بيمنع أي splash/ripple ثقيل يأثر بصريًا على النصوص المترجمة الطويلة
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.white),
        actionsIconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: AppTypography.headlineMedium(languageCode).copyWith(
          color: AppColors.white,
          fontFamily: fontFamily,
        ),
        // يمنع تشوه العنوان إذا الترجمة طويلة
        toolbarTextStyle: AppTypography.bodyMedium(languageCode).copyWith(
          color: AppColors.white,
          fontFamily: fontFamily,
        ),
      ),

      cardTheme: CardThemeData(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        elevation: 2,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius.r),
        ),
      ),

      textTheme: _buildTextTheme(colorScheme, fontFamily, languageCode),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: AppColors.white,
          minimumSize: Size(double.infinity, AppConstants.buttonHeight.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius.r),
          ),
          textStyle: AppTypography.labelLarge(languageCode).copyWith(fontFamily: fontFamily),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: Size(double.infinity, AppConstants.buttonHeight.h),
          side: BorderSide(color: colorScheme.primary, width: 0.75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius.r),
          ),
          textStyle: AppTypography.labelLarge(languageCode).copyWith(fontFamily: fontFamily),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: AppTypography.labelMedium(languageCode).copyWith(fontFamily: fontFamily),
        ),
      ),

      inputDecorationTheme: _buildInputTheme(colorScheme, isDark, languageCode, fontFamily),

      dividerTheme: DividerThemeData(color: colorScheme.outline, thickness: 1),
      iconTheme: IconThemeData(color: colorScheme.onSurface),

      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius.r),
        ),
        titleTextStyle: AppTypography.headlineSmall(languageCode).copyWith(
          color: colorScheme.onSurface,
          fontFamily: fontFamily,
        ),
        contentTextStyle: AppTypography.bodyMedium(languageCode).copyWith(
          color: colorScheme.onSurfaceVariant,
          fontFamily: fontFamily,
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.borderRadius.r)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.darkBorder : AppColors.black,
        contentTextStyle: AppTypography.bodyMedium(languageCode).copyWith(
          color: AppColors.white,
          fontFamily: fontFamily,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius.r),
        ),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: AppTypography.labelLarge(languageCode).copyWith(fontFamily: fontFamily),
        unselectedLabelStyle: AppTypography.labelMedium(languageCode).copyWith(fontFamily: fontFamily),
      ),
    );
  }

  static ColorScheme get _lightScheme => const ColorScheme.light(
    primary: AppColors.lightPrimary,
    secondary: AppColors.primary,
    surface: AppColors.lightScaffold,
    onSurface: AppColors.lightTextPrimary,
    onSurfaceVariant: AppColors.lightTextSecondary,
    outline: AppColors.lightBorder,
    shadow: AppColors.black,
    error: AppColors.red,
  );

  static ColorScheme get _darkScheme => const ColorScheme.dark(
    primary: AppColors.darkPrimary,
    secondary: AppColors.primary,
    surface: AppColors.darkScaffold,
    onSurface: AppColors.darkTextPrimary,
    onSurfaceVariant: AppColors.darkTextSecondary,
    outline: AppColors.darkBorder,
    shadow: AppColors.black,
    error: AppColors.red,
  );

  static TextTheme _buildTextTheme(ColorScheme scheme, String family, String languageCode) {
    return TextTheme(
      headlineLarge: AppTypography.headlineLarge(languageCode).copyWith(color: scheme.onSurface, fontFamily: family),
      headlineMedium: AppTypography.headlineMedium(languageCode).copyWith(color: scheme.onSurface, fontFamily: family),
      headlineSmall: AppTypography.headlineSmall(languageCode).copyWith(color: scheme.onSurface, fontFamily: family),
      bodyLarge: AppTypography.bodyLarge(languageCode).copyWith(color: scheme.onSurface, fontFamily: family),
      bodyMedium: AppTypography.bodyMedium(languageCode).copyWith(color: scheme.onSurfaceVariant, fontFamily: family),
      bodySmall: AppTypography.bodySmall(languageCode).copyWith(color: scheme.onSurfaceVariant, fontFamily: family),
      labelLarge: AppTypography.labelLarge(languageCode).copyWith(color: AppColors.white, fontFamily: family),
      labelMedium: AppTypography.labelMedium(languageCode).copyWith(color: scheme.onSurfaceVariant, fontFamily: family),
      labelSmall: AppTypography.labelSmall(languageCode).copyWith(color: scheme.onSurfaceVariant, fontFamily: family),
    );
  }

  static InputDecorationTheme _buildInputTheme(
    ColorScheme scheme,
    bool isDark,
    String languageCode,
    String fontFamily,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.darkSurface : AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: AppTypography.bodyMedium(languageCode).copyWith(
        color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
        fontFamily: fontFamily,
      ),
      errorStyle: AppTypography.labelSmall(languageCode).copyWith(
        color: AppColors.red,
        fontFamily: fontFamily,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: scheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.red, width: 2),
      ),
    );
  }
}