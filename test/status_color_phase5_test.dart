import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_theme.dart';
import 'package:car_care/features/spare_parts_store/shared/presentation/widgets/order_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

const _surfaceSize = Size(375, 800);

Future<BuildContext> _pumpThemedContext(
  WidgetTester tester, {
  required bool isDark,
}) async {
  late BuildContext capturedContext;
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: _surfaceSize,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.createTheme(isDark: isDark, languageCode: 'ar'),
        home: Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox();
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return capturedContext;
}

void main() {
  testWidgets('completed/delivered resolves to the success semantic color', (
    tester,
  ) async {
    final lightContext = await _pumpThemedContext(tester, isDark: false);
    expect(
      orderStatusColor(lightContext, 'delivered'),
      AppColors.successColor(lightContext),
    );

    final darkContext = await _pumpThemedContext(tester, isDark: true);
    expect(
      orderStatusColor(darkContext, 'delivered'),
      AppColors.darkSuccess,
    );
  });

  testWidgets('pending resolves to the warning semantic color', (
    tester,
  ) async {
    final lightContext = await _pumpThemedContext(tester, isDark: false);
    expect(
      orderStatusColor(lightContext, 'pending'),
      AppColors.warningColor(lightContext),
    );

    final darkContext = await _pumpThemedContext(tester, isDark: true);
    expect(orderStatusColor(darkContext, 'pending'), AppColors.darkWarning);
  });

  testWidgets('cancelled/rejected resolves to the error semantic color', (
    tester,
  ) async {
    final lightContext = await _pumpThemedContext(tester, isDark: false);
    expect(
      orderStatusColor(lightContext, 'cancelled'),
      Theme.of(lightContext).colorScheme.error,
    );

    final darkContext = await _pumpThemedContext(tester, isDark: true);
    expect(
      orderStatusColor(darkContext, 'rejected'),
      Theme.of(darkContext).colorScheme.error,
    );
  });

  testWidgets('in-progress states resolve to the info/primary semantic color', (
    tester,
  ) async {
    final lightContext = await _pumpThemedContext(tester, isDark: false);
    expect(
      orderStatusColor(lightContext, 'processing'),
      Theme.of(lightContext).colorScheme.primary,
    );
    expect(
      orderStatusColor(lightContext, 'accepted'),
      Theme.of(lightContext).colorScheme.primary,
    );

    final darkContext = await _pumpThemedContext(tester, isDark: true);
    expect(
      orderStatusColor(darkContext, 'processing'),
      Theme.of(darkContext).colorScheme.primary,
    );
  });
}
