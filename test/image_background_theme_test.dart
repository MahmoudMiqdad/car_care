import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_theme.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

const _surfaceSize = Size(375, 800);

Future<void> _pumpBackground(WidgetTester tester, {required bool isDark}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: _surfaceSize,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.createTheme(isDark: isDark, languageCode: 'ar'),
        home: const ImageBackground(child: SizedBox()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('light theme uses the existing artboard background asset', (
    tester,
  ) async {
    await _pumpBackground(tester, isDark: false);
    final image = tester.widget<Image>(find.byType(Image));
    final provider = image.image as AssetImage;
    expect(provider.assetName, AppAssets.artboardBackground);
  });

  testWidgets('dark theme uses the DarkBack.png asset directly', (
    tester,
  ) async {
    await _pumpBackground(tester, isDark: true);
    final image = tester.widget<Image>(find.byType(Image));
    final provider = image.image as AssetImage;
    expect(provider.assetName, AppAssets.darkBackground);
    expect(image.colorBlendMode, isNull);
    expect(find.byType(Opacity), findsNothing);
  });
}
