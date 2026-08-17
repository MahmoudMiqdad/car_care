// Regression coverage for the E2E bug report: a valid, freshly-received OTP
// was rejected by /auth/verify-reset-otp as "invalid/expired". Root cause
// was the OTP boxes Row inheriting the app's ambient RTL Directionality,
// which visually reverses box order relative to the controllers[0..5]
// index order used to build the submitted otp string.
import 'package:car_care/features/auth/domain/model/auth_model.dart';
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_cubit.dart';
import 'package:car_care/features/auth/presentation/widgets/forgot_password/otp_verification_card.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

Future<PasswordResetCubit> _pumpOtpCard(
  WidgetTester tester,
  MockIAuthRepository repository, {
  Locale locale = const Locale('ar'),
}) async {
  when(
    () => repository.requestPasswordReset(any()),
  ).thenAnswer((_) async => const Right('sent'));
  final cubit = PasswordResetCubit(repository);
  addTearDown(cubit.close);
  await cubit.sendOtp('user@example.com');

  final isRtl = locale.languageCode == 'ar';
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
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

Future<void> _typeDigits(WidgetTester tester, List<String> digits) async {
  final fields = find.byType(TextField);
  for (var i = 0; i < digits.length; i++) {
    await tester.enterText(fields.at(i), digits[i]);
    await tester.pump();
  }
}

/// Returns the 6 OTP box Finders ordered by their actual on-screen x
/// position (left to right) rather than by widget-tree/controller index —
/// i.e. the order a real user taps them in. Under the pre-fix RTL bug this
/// differs from tree order (box index0 rendered rightmost), which is
/// exactly what caused the reported OTP-mismatch bug.
List<Finder> _fieldsInVisualOrder(WidgetTester tester) {
  final fields = find.byType(TextField);
  final byX = List.generate(
    otpLength,
    (i) => MapEntry(i, tester.getTopLeft(fields.at(i)).dx),
  )..sort((a, b) => a.value.compareTo(b.value));

  return byX.map((e) => fields.at(e.key)).toList();
}

/// Types [digits] left-to-right by actual screen position — simulating a
/// user who reads/taps the boxes visually left-to-right, as the product
/// spec requires ("digit1 → digit2 → ... → digit6" stays LTR even in the
/// Arabic RTL app).
Future<void> _typeDigitsByVisualOrder(
  WidgetTester tester,
  List<String> digits,
) async {
  final orderedFields = _fieldsInVisualOrder(tester);
  for (var i = 0; i < digits.length; i++) {
    await tester.enterText(orderedFields[i], digits[i]);
    await tester.pump();
  }
}

void main() {
  group('OTP order — verify-reset-otp E2E regression', () {
    late MockIAuthRepository repository;

    setUp(() => repository = MockIAuthRepository());

    testWidgets(
      'box index0 renders leftmost even under the app RTL Directionality '
      '(the ambient RTL must not flip the OTP box order)',
      (tester) async {
        await _pumpOtpCard(tester, repository, locale: const Locale('ar'));

        final fields = find.byType(TextField);
        final xPositions = List.generate(
          otpLength,
          (i) => tester.getTopLeft(fields.at(i)).dx,
        );

        for (var i = 0; i < otpLength - 1; i++) {
          expect(
            xPositions[i],
            lessThan(xPositions[i + 1]),
            reason:
                'box $i must render to the left of box ${i + 1}, matching '
                'controllers[0..5] order used to build the submitted otp',
          );
        }

        await tester.pumpWidget(const SizedBox());
      },
    );

    testWidgets('typing 7 3 9 5 9 9 sends otp "739599" verbatim', (
      tester,
    ) async {
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
      await _typeDigitsByVisualOrder(tester, ['7', '3', '9', '5', '9', '9']);
      await tester.pump();

      final captured = verify(
        () => repository.verifyResetOtp(
          email: captureAny(named: 'email'),
          otp: captureAny(named: 'otp'),
        ),
      ).captured;

      expect(captured[0], 'user@example.com');
      expect(captured[1], '739599');

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('RTL locale does not reverse the OTP order', (tester) async {
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

      await _pumpOtpCard(tester, repository, locale: const Locale('ar'));
      await _typeDigitsByVisualOrder(tester, ['1', '2', '3', '4', '5', '6']);
      await tester.pump();

      final captured = verify(
        () => repository.verifyResetOtp(
          email: any(named: 'email'),
          otp: captureAny(named: 'otp'),
        ),
      ).captured;

      expect(captured.single, '123456');

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets(
      'the verify request body carries the correct email and otp together',
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
        await _typeDigitsByVisualOrder(tester, ['4', '4', '1', '2', '2', '3']);
        await tester.pump();

        verify(
          () => repository.verifyResetOtp(
            email: 'user@example.com',
            otp: '441223',
          ),
        ).called(1);

        await tester.pumpWidget(const SizedBox());
      },
    );
  });

  group('OTP box focus behavior', () {
    late MockIAuthRepository repository;
    setUp(() => repository = MockIAuthRepository());

    testWidgets(
      'entering a digit advances focus box-by-box through all 6 fields',
      (tester) async {
        await _pumpOtpCard(tester, repository);
        final fields = find.byType(TextField);

        for (var i = 0; i < otpLength - 1; i++) {
          await tester.enterText(fields.at(i), '${i + 1}');
          await tester.pump();

          final nextField = tester.widget<TextField>(fields.at(i + 1));
          expect(
            nextField.focusNode!.hasFocus,
            isTrue,
            reason: 'box $i should hand focus to box ${i + 1}',
          );
        }

        await tester.pumpWidget(const SizedBox());
      },
    );

    testWidgets(
      'backspace on an already-empty box returns focus to the previous box',
      (tester) async {
        await _pumpOtpCard(tester, repository);
        final fields = find.byType(TextField);

        await tester.tap(fields.at(2));
        await tester.pump();
        expect(tester.widget<TextField>(fields.at(2)).focusNode!.hasFocus, isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pump();

        expect(tester.widget<TextField>(fields.at(1)).focusNode!.hasFocus, isTrue);

        await tester.pumpWidget(const SizedBox());
      },
    );

    testWidgets('confirm button is disabled until all 6 digits are filled', (
      tester,
    ) async {
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

      ElevatedButton button() =>
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(button().onPressed, isNull);

      await _typeDigits(tester, ['1', '2', '3', '4', '5']);
      expect(button().onPressed, isNull);

      await tester.enterText(find.byType(TextField).at(5), '6');
      await tester.pump();
      await tester.pump();

      expect(button().onPressed, isNotNull);

      await tester.pumpWidget(const SizedBox());
    });
  });
}
