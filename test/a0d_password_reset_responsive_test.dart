// Verifies the Forgot Password / OTP / Reset Password widgets render
// without a RenderFlex overflow at small real-device widths (320-412),
// in Arabic (RTL), matching the pattern in custom_appbar_layout_test.dart.
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_cubit.dart';
import 'package:car_care/features/auth/presentation/widgets/forgot_password/forgot_password_content.dart';
import 'package:car_care/features/auth/presentation/widgets/forgot_password/otp_verification_card.dart';
import 'package:car_care/features/auth/presentation/widgets/reset_password/reset_password_content.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

Future<void> _pumpAt(
  WidgetTester tester, {
  required double logicalWidth,
  required Widget child,
}) async {
  tester.view.physicalSize = Size(logicalWidth, logicalWidth * 2.16);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: child),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  const widths = [320.0, 360.0, 390.0, 412.0];

  late MockIAuthRepository repository;

  setUp(() {
    repository = MockIAuthRepository();
  });

  for (final width in widths) {
    testWidgets(
      'ForgotPasswordContent has no overflow at ${width}px width',
      (tester) async {
        await _pumpAt(
          tester,
          logicalWidth: width,
          child: BlocProvider(
            create: (_) => PasswordResetCubit(repository),
            child: const ForgotPasswordContent(),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('OtpVerificationCard has no overflow at ${width}px width', (
      tester,
    ) async {
      when(() => repository.requestPasswordReset(any())).thenAnswer(
        (_) async => const Right('sent'),
      );
      final cubit = PasswordResetCubit(repository);
      addTearDown(cubit.close);
      await cubit.sendOtp('mahmoud@example.com');

      await _pumpAt(
        tester,
        logicalWidth: width,
        child: BlocProvider.value(
          value: cubit,
          child: const OtpVerificationCard(),
        ),
      );

      expect(tester.takeException(), isNull);

      // Unmount so the card's cooldown Timer.periodic is cancelled in
      // dispose() before the test ends — otherwise it leaks past teardown.
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets(
      'ResetPasswordContent has no overflow at ${width}px width',
      (tester) async {
        final cubit = PasswordResetCubit(repository)
          ..seedVerified(email: 'mahmoud@example.com', resetToken: 'tok');
        addTearDown(cubit.close);

        await _pumpAt(
          tester,
          logicalWidth: width,
          child: BlocProvider.value(
            value: cubit,
            child: ResetPasswordContent(onSuccess: (_) {}),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );
  }
}
