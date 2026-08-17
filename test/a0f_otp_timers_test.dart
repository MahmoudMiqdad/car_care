// Verifies the two independent OTP timers on the verification card:
// - OTP expiry: 5 minutes (300s), server-defined, blocks verify once elapsed
// - Resend cooldown: 30s, UI-only, gates the "resend code" affordance
// They must never be conflated into a single timer/countdown.
import 'package:car_care/features/auth/domain/model/auth_model.dart';
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_cubit.dart';
import 'package:car_care/features/auth/presentation/widgets/forgot_password/otp_verification_card.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

Future<PasswordResetCubit> _pumpOtpCard(
  WidgetTester tester,
  MockIAuthRepository repository,
) async {
  when(
    () => repository.requestPasswordReset(any()),
  ).thenAnswer((_) async => const Right('sent'));
  final cubit = PasswordResetCubit(repository);
  addTearDown(cubit.close);
  await cubit.sendOtp('user@example.com');

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: const OtpVerificationCard(),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return cubit;
}

Future<void> _fillAllBoxes(WidgetTester tester, List<String> digits) async {
  final fields = find.byType(TextField);
  for (var i = 0; i < digits.length; i++) {
    await tester.enterText(fields.at(i), digits[i]);
    await tester.pump();
  }
}

bool _confirmEnabled(WidgetTester tester) =>
    tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed !=
    null;

void main() {
  late MockIAuthRepository repository;

  setUp(() => repository = MockIAuthRepository());

  testWidgets(
    'on open: OTP expiry shows 05:00 and resend is disabled (30s cooldown)',
    (tester) async {
      await _pumpOtpCard(tester, repository);

      expect(find.textContaining('05:00'), findsOneWidget);
      expect(find.textContaining('00:30'), findsOneWidget);
      // The tappable "resend code" text must not exist yet — only the
      // "resend in 00:30" countdown label.
      expect(find.text('إعادة إرسال الرمز'), findsNothing);

      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'after 30s: resend is enabled and the OTP is still not expired',
    (tester) async {
      await _pumpOtpCard(tester, repository);

      await tester.pump(const Duration(seconds: 30));

      expect(find.text('إعادة إرسال الرمز'), findsOneWidget);
      // ~04:30 left on the independent expiry timer — not reset, not zero.
      expect(find.textContaining('04:30'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'at 4:59 elapsed (299s), just before the 5-minute mark, the OTP is '
    'still confirmable',
    (tester) async {
      when(
        () => repository.verifyResetOtp(
          email: any(named: 'email'),
          otp: any(named: 'otp'),
        ),
      ).thenAnswer(
        (_) async => Right(
          ResetOtpVerification(resetToken: 'tok', expiresInMinutes: 15),
        ),
      );

      await _pumpOtpCard(tester, repository);
      await tester.pump(const Duration(seconds: 299));
      await _fillAllBoxes(tester, ['1', '2', '3', '4', '5', '6']);
      await tester.pump();

      expect(_confirmEnabled(tester), isTrue);
      verify(
        () => repository.verifyResetOtp(
          email: 'user@example.com',
          otp: '123456',
        ),
      ).called(1);

      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'at the 5-minute mark the OTP is expired: confirm stays disabled and '
    'verify is never called for the stale code',
    (tester) async {
      await _pumpOtpCard(tester, repository);
      await tester.pump(const Duration(seconds: 300));
      await _fillAllBoxes(tester, ['1', '2', '3', '4', '5', '6']);
      await tester.pump();

      expect(_confirmEnabled(tester), isFalse);
      // Both the inline card label and the one-shot snackbar show the
      // expiry notice — at least one must be visible.
      expect(find.textContaining('انتهت صلاحية الرمز'), findsWidgets);
      verifyNever(
        () => repository.verifyResetOtp(
          email: any(named: 'email'),
          otp: any(named: 'otp'),
        ),
      );

      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'resend success resets expiry to 05:00, cooldown to 00:30, and clears '
    'the OTP boxes',
    (tester) async {
      when(
        () => repository.requestPasswordReset(any()),
      ).thenAnswer((_) async => const Right('otp resent'));

      await _pumpOtpCard(tester, repository);
      // Let time pass so both timers have visibly moved before resetting.
      await tester.pump(const Duration(seconds: 45));
      // Deliberately leave the 6th box empty — filling all 6 auto-submits,
      // which isn't what this test is exercising.
      await _fillAllBoxes(tester, ['1', '2', '3', '4', '5']);

      await tester.tap(find.text('إعادة إرسال الرمز'));
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('05:00'), findsOneWidget);
      expect(find.textContaining('00:30'), findsOneWidget);

      final fields = find.byType(TextField);
      for (var i = 0; i < otpLength; i++) {
        expect(tester.widget<TextField>(fields.at(i)).controller!.text, '');
      }

      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('OTP order under RTL is unaffected by the timer changes', (
    tester,
  ) async {
    when(
      () => repository.verifyResetOtp(
        email: any(named: 'email'),
        otp: any(named: 'otp'),
      ),
    ).thenAnswer(
      (_) async =>
          Right(ResetOtpVerification(resetToken: 'tok', expiresInMinutes: 15)),
    );

    await _pumpOtpCard(tester, repository);
    final fields = find.byType(TextField);
    final byX = List.generate(
      otpLength,
      (i) => MapEntry(i, tester.getTopLeft(fields.at(i)).dx),
    )..sort((a, b) => a.value.compareTo(b.value));
    final visualOrderFields = byX.map((e) => fields.at(e.key)).toList();

    const digits = ['7', '3', '9', '5', '9', '9'];
    for (var i = 0; i < digits.length; i++) {
      await tester.enterText(visualOrderFields[i], digits[i]);
      await tester.pump();
    }

    verify(
      () => repository.verifyResetOtp(
        email: 'user@example.com',
        otp: '739599',
      ),
    ).called(1);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('auto-focus between boxes still works after the timer changes', (
    tester,
  ) async {
    await _pumpOtpCard(tester, repository);
    final fields = find.byType(TextField);

    for (var i = 0; i < otpLength - 1; i++) {
      await tester.enterText(fields.at(i), '${i + 1}');
      await tester.pump();

      expect(
        tester.widget<TextField>(fields.at(i + 1)).focusNode!.hasFocus,
        isTrue,
        reason: 'box $i should hand focus to box ${i + 1}',
      );
    }

    await tester.pumpWidget(const SizedBox());
  });
}
