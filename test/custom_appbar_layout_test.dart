// يثبت أن CustomAppBar (زر رجوع + عنوان + Action) لا يسبب RenderFlex
// overflow عند عروض شاشة واقعية بالعربية والإنجليزية.
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpAppBarAt(
  WidgetTester tester, {
  required double logicalWidth,
  required Locale locale,
  bool withAction = false,
}) async {
  tester.view.physicalSize = Size(logicalWidth, logicalWidth * 2.16);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: CustomAppBar(
            title: 'عنوان الصفحة',
            actionWidget: withAction
                ? const Icon(Icons.shopping_cart_outlined, color: Colors.white)
                : null,
          ),
          body: const SizedBox(),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  for (final width in [320.0, 360.0, 375.0, 412.0]) {
    for (final locale in [const Locale('ar'), const Locale('en')]) {
      testWidgets(
        'لا يوجد Overflow عند عرض $width بلغة ${locale.languageCode}',
        (tester) async {
          await pumpAppBarAt(tester, logicalWidth: width, locale: locale);
          expect(tester.takeException(), isNull);
          expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
          expect(find.text('عنوان الصفحة'), findsOneWidget);
        },
      );

      testWidgets(
        'لا يوجد Overflow مع Action عند عرض $width بلغة ${locale.languageCode}',
        (tester) async {
          await pumpAppBarAt(
            tester,
            logicalWidth: width,
            locale: locale,
            withAction: true,
          );
          expect(tester.takeException(), isNull);
          expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
          expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
        },
      );
    }
  }
}
