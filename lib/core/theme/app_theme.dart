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
    final chromeBackground = isDark
        ? colorScheme.surfaceContainerLowest
        : colorScheme.primary;
    final chromeForeground = isDark
        ? colorScheme.onSurface
        : colorScheme.onPrimary;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      fontFamily: fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,

      appBarTheme: AppBarTheme(
        backgroundColor: chromeBackground,
        foregroundColor: chromeForeground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: chromeForeground),
        actionsIconTheme: IconThemeData(color: chromeForeground),
        titleTextStyle: AppTypography.headlineMedium(
          languageCode,
        ).copyWith(color: chromeForeground, fontFamily: fontFamily),
        toolbarTextStyle: AppTypography.bodyMedium(
          languageCode,
        ).copyWith(color: chromeForeground, fontFamily: fontFamily),
      ),

      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainer,
        elevation: 2,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius.r),
        ),
      ),

      textTheme: _buildTextTheme(colorScheme, fontFamily, languageCode),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.12);
            }
            return isDark ? Colors.transparent : AppColors.accent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return isDark ? AppColors.accent : AppColors.white;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (!isDark) return null;
            final disabled = states.contains(WidgetState.disabled);
            return BorderSide(
              color: disabled
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : AppColors.accent,
              width: 1.5,
            );
          }),
          elevation: const WidgetStatePropertyAll(0),
          minimumSize: WidgetStatePropertyAll(
            Size(double.infinity, AppConstants.buttonHeight.h),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius.r),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            AppTypography.labelLarge(
              languageCode,
            ).copyWith(fontFamily: fontFamily),
          ),
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
          textStyle: AppTypography.labelLarge(
            languageCode,
          ).copyWith(fontFamily: fontFamily),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: AppTypography.labelMedium(
            languageCode,
          ).copyWith(fontFamily: fontFamily),
        ),
      ),

      inputDecorationTheme: _buildInputTheme(
        colorScheme,
        languageCode,
        fontFamily,
      ),

      dividerTheme: DividerThemeData(color: colorScheme.outline, thickness: 1),
      iconTheme: IconThemeData(color: colorScheme.onSurface),

      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius.r),
        ),
        titleTextStyle: AppTypography.headlineSmall(
          languageCode,
        ).copyWith(color: colorScheme.onSurface, fontFamily: fontFamily),
        contentTextStyle: AppTypography.bodyMedium(
          languageCode,
        ).copyWith(color: colorScheme.onSurfaceVariant, fontFamily: fontFamily),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.borderRadius.r),
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium(
          languageCode,
        ).copyWith(color: colorScheme.onInverseSurface, fontFamily: fontFamily),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius.r),
        ),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: AppTypography.labelLarge(
          languageCode,
        ).copyWith(fontFamily: fontFamily),
        unselectedLabelStyle: AppTypography.labelMedium(
          languageCode,
        ).copyWith(fontFamily: fontFamily),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        indicatorColor: colorScheme.secondaryContainer,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppTypography.labelSmall(languageCode).copyWith(
            color: states.contains(WidgetState.selected)
                ? colorScheme.onSecondaryContainer
                : colorScheme.onSurfaceVariant,
            fontFamily: fontFamily,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colorScheme.onSecondaryContainer
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  static Color _tint(Color base, double amount) =>
      Color.lerp(base, Colors.white, amount)!;

  static Color _shade(Color base, double amount) =>
      Color.lerp(base, Colors.black, amount)!;

  static ColorScheme get _lightScheme => ColorScheme.light(
    primary: AppColors.lightPrimary,
    onPrimary: AppColors.white,
    primaryContainer: _tint(AppColors.lightPrimary, 0.82),
    onPrimaryContainer: _shade(AppColors.lightPrimary, 0.35),
    secondary: AppColors.secondary,
    onSecondary: AppColors.lightTextPrimary,
    secondaryContainer: AppColors.secondary,
    onSecondaryContainer: AppColors.lightTextPrimary,
    tertiary: AppColors.accent,
    onTertiary: AppColors.black,
    tertiaryContainer: _tint(AppColors.accent, 0.78),
    onTertiaryContainer: AppColors.lightTextPrimary,
    surface: AppColors.lightScaffold,
    onSurface: AppColors.lightTextPrimary,
    surfaceContainer: AppColors.white,
    surfaceContainerHighest: _shade(AppColors.lightScaffold, 0.06),
    onSurfaceVariant: AppColors.lightTextSecondary,
    outline: AppColors.lightBorder,
    outlineVariant: _tint(AppColors.lightBorder, 0.35),
    error: AppColors.red,
    onError: AppColors.white,
    errorContainer: AppColors.errorBannerSurface,
    onErrorContainer: _shade(AppColors.red, 0.3),
    inverseSurface: AppColors.darkScaffold,
    onInverseSurface: AppColors.darkTextPrimary,
    inversePrimary: AppColors.darkPrimary,
    shadow: AppColors.black,
    scrim: AppColors.black,
  );

  static ColorScheme get _darkScheme => ColorScheme.dark(
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.white,
    primaryContainer: _shade(AppColors.darkPrimary, 0.45),
    onPrimaryContainer: _tint(AppColors.darkPrimary, 0.55),
    secondary: AppColors.darkPrimaryInteractive,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.darkPrimaryInteractive,
    onSecondaryContainer: AppColors.darkTextPrimary,
    tertiary: AppColors.accent,
    onTertiary: AppColors.black,
    tertiaryContainer: _shade(AppColors.accent, 0.45),
    onTertiaryContainer: AppColors.darkTextPrimary,
    surface: AppColors.darkScaffold,
    onSurface: AppColors.darkTextPrimary,
    surfaceContainerLowest: AppColors.darkAppBarChrome,
    surfaceContainer: AppColors.darkSurface,
    surfaceContainerHighest: AppColors.darkSecondarySurface,
    onSurfaceVariant: AppColors.darkTextSecondary,
    outline: AppColors.darkBorder,
    outlineVariant: _shade(AppColors.darkBorder, 0.25),
    error: AppColors.darkError,
    onError: AppColors.white,
    errorContainer: _shade(AppColors.darkError, 0.45),
    onErrorContainer: _tint(AppColors.darkError, 0.7),
    inverseSurface: AppColors.lightScaffold,
    onInverseSurface: AppColors.lightTextPrimary,
    inversePrimary: AppColors.lightPrimary,
    shadow: AppColors.black,
    scrim: AppColors.black,
  );

  static TextTheme _buildTextTheme(
    ColorScheme scheme,
    String family,
    String languageCode,
  ) {
    return TextTheme(
      headlineLarge: AppTypography.headlineLarge(
        languageCode,
      ).copyWith(color: scheme.onSurface, fontFamily: family),
      headlineMedium: AppTypography.headlineMedium(
        languageCode,
      ).copyWith(color: scheme.onSurface, fontFamily: family),
      headlineSmall: AppTypography.headlineSmall(
        languageCode,
      ).copyWith(color: scheme.onSurface, fontFamily: family),
      bodyLarge: AppTypography.bodyLarge(
        languageCode,
      ).copyWith(color: scheme.onSurface, fontFamily: family),
      bodyMedium: AppTypography.bodyMedium(
        languageCode,
      ).copyWith(color: scheme.onSurfaceVariant, fontFamily: family),
      bodySmall: AppTypography.bodySmall(
        languageCode,
      ).copyWith(color: scheme.onSurfaceVariant, fontFamily: family),
      labelLarge: AppTypography.labelLarge(
        languageCode,
      ).copyWith(color: scheme.onSurface, fontFamily: family),
      labelMedium: AppTypography.labelMedium(
        languageCode,
      ).copyWith(color: scheme.onSurfaceVariant, fontFamily: family),
      labelSmall: AppTypography.labelSmall(
        languageCode,
      ).copyWith(color: scheme.onSurfaceVariant, fontFamily: family),
    );
  }

  static InputDecorationTheme _buildInputTheme(
    ColorScheme scheme,
    String languageCode,
    String fontFamily,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: scheme.brightness == Brightness.dark
          ? scheme.surfaceContainerHighest
          : scheme.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: AppTypography.bodyMedium(languageCode).copyWith(
        color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
        fontFamily: fontFamily,
      ),
      labelStyle: AppTypography.bodyMedium(
        languageCode,
      ).copyWith(color: scheme.onSurfaceVariant, fontFamily: fontFamily),
      floatingLabelStyle: AppTypography.bodySmall(
        languageCode,
      ).copyWith(color: scheme.primary, fontFamily: fontFamily),
      errorStyle: AppTypography.labelSmall(
        languageCode,
      ).copyWith(color: scheme.error, fontFamily: fontFamily),
      prefixIconColor: scheme.onSurfaceVariant,
      suffixIconColor: scheme.onSurfaceVariant,
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
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.25)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: scheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: scheme.error, width: 2),
      ),
    );
  }
}
