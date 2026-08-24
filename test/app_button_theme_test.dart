import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_theme.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

const _surfaceSize = Size(375, 800);

Future<void> _pumpButton(
  WidgetTester tester, {
  required bool isDark,
  VoidCallback? onPressed,
}) async {
  tester.view.physicalSize = _surfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: _surfaceSize,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.createTheme(isDark: isDark, languageCode: 'ar'),
        home: Scaffold(
          body: AppButton(onPressed: onPressed, text: 'Save'),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('light theme ordinary CTA fills with the accent orange', (
    tester,
  ) async {
    await _pumpButton(tester, isDark: false, onPressed: () {});
    final elevated = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    final style = elevated.style!;
    final states = <WidgetState>{};
    expect(style.backgroundColor!.resolve(states), AppColors.accent);
    expect(style.foregroundColor!.resolve(states), AppColors.white);
  });

  testWidgets(
    'dark theme ordinary CTA is transparent with an accent outline and text',
    (tester) async {
      await _pumpButton(tester, isDark: true, onPressed: () {});
      expect(find.byType(ElevatedButton), findsNothing);
      final outlined = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );
      final style = outlined.style!;
      final states = <WidgetState>{};
      expect(style.backgroundColor!.resolve(states), Colors.transparent);
      expect(style.foregroundColor!.resolve(states), AppColors.accent);
      final side = style.side!.resolve(states)!;
      expect(side.color, AppColors.accent);

      final text = tester.widget<Text>(find.text('Save'));
      expect(text.style!.color, AppColors.accent);
    },
  );

  testWidgets('disabled dark theme CTA is visibly muted, not active orange', (
    tester,
  ) async {
    await _pumpButton(tester, isDark: true, onPressed: null);
    final outlined = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    expect(outlined.onPressed, isNull);
    final side = outlined.style!.side!.resolve({WidgetState.disabled})!;
    expect(side.color, AppColors.accent.withOpacity(0.5));
  });
}
