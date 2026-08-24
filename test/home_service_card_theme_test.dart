import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_theme.dart';
import 'package:car_care/features/home/presentation/widgets/ServicesGrid.dart';
import 'package:car_care/features/home/presentation/widgets/service_card.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

const _surfaceSize = Size(375, 800);

Future<void> _pumpCard(WidgetTester tester, {required bool isDark}) async {
  tester.view.physicalSize = _surfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: _surfaceSize,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.createTheme(isDark: isDark, languageCode: 'ar'),
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ServiceCard(
            item: const ServiceItemData(title: 'مركباتي', imagePath: ''),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  final cardMaterial = find.descendant(
    of: find.byType(ServiceCard),
    matching: find.byType(Material),
  );

  testWidgets('light theme service card resolves to the light card surface', (
    tester,
  ) async {
    await _pumpCard(tester, isDark: false);
    final context = tester.element(find.byType(ServiceCard));
    final material = tester.widget<Material>(cardMaterial);
    expect(material.color, AppColors.cardBackground(context));
    expect(material.color, isNot(AppColors.darkSurface));
  });

  testWidgets('dark theme service card resolves to the dark card surface', (
    tester,
  ) async {
    await _pumpCard(tester, isDark: true);
    final context = tester.element(find.byType(ServiceCard));
    final material = tester.widget<Material>(cardMaterial);
    expect(material.color, AppColors.cardBackground(context));
    expect(material.color, AppColors.darkSurface);
    expect(material.color, isNot(Colors.white));
  });

  testWidgets('dark theme service card title uses the readable onSurface role', (
    tester,
  ) async {
    await _pumpCard(tester, isDark: true);
    final context = tester.element(find.byType(ServiceCard));
    final text = tester.widget<Text>(find.text('مركباتي'));
    expect(text.style!.color, Theme.of(context).colorScheme.onSurface);
  });
}
