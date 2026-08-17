import 'dart:async';

import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_cubit.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

const int otpLength = 6;
const int resendCooldownSeconds = 30;
// OTP validity (5 minutes) is a distinct, independent duration from the
// resend cooldown above — see the two separate Timers in the State class.
const int otpExpirySeconds = 300;

String _formatMmSs(int seconds) {
  final m = (seconds ~/ 60).toString().padLeft(2, '0');
  final s = (seconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

/// Masks an email's local part for display, e.g. mahmoud@gmail.com -> m*****@gmail.com.
String maskEmail(String email) {
  final atIndex = email.indexOf('@');
  if (atIndex <= 0) return email;

  final localPart = email.substring(0, atIndex);
  final domainPart = email.substring(atIndex);
  final visible = localPart.substring(0, 1);
  final maskLength = localPart.length - 1;
  final masked = '$visible${'*' * (maskLength > 0 ? maskLength : 0)}';
  return '$masked$domainPart';
}

class OtpVerificationCard extends StatefulWidget {
  const OtpVerificationCard({super.key});

  @override
  State<OtpVerificationCard> createState() => _OtpVerificationCardState();
}

class _OtpVerificationCardState extends State<OtpVerificationCard> {
  late final List<TextEditingController> _controllers = List.generate(
    otpLength,
    (_) => TextEditingController(),
  );
  late final List<FocusNode> _focusNodes = List.generate(
    otpLength,
    (_) => FocusNode(),
  );

  // Two independent Timers on purpose: OTP expiry (5 min, server-defined)
  // and the resend cooldown (30 sec, UI-only) never move together — e.g.
  // 1 minute in, expiry is ~04:00 left while resend is already enabled.
  Timer? _cooldownTimer;
  int _secondsLeft = resendCooldownSeconds;

  Timer? _expiryTimer;
  int _expirySecondsLeft = otpExpirySeconds;

  bool _wasResendTransition = false;

  bool get _isExpired => _expirySecondsLeft <= 0;

  @override
  void initState() {
    super.initState();
    _startCooldown();
    _startExpiryTimer();
    for (final f in _focusNodes) {
      f.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _expiryTimer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f
        ..removeListener(_onFocusChange)
        ..dispose();
    }
    super.dispose();
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _secondsLeft = resendCooldownSeconds);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  void _startExpiryTimer() {
    _expiryTimer?.cancel();
    setState(() => _expirySecondsLeft = otpExpirySeconds);
    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_expirySecondsLeft <= 1) {
        timer.cancel();
        setState(() => _expirySecondsLeft = 0);
        if (mounted) {
          AppSnackBar.error(context, context.l10n.otpExpiredNotice);
        }
      } else {
        setState(() => _expirySecondsLeft -= 1);
      }
    });
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _clearFields() {
    for (final c in _controllers) {
      c.clear();
    }
    FocusScope.of(context).requestFocus(_focusNodes.first);
  }

  void _onBoxChanged(int index, String value) {
    if (value.length > 1) {
      // Handles a full-code paste landing in a single box.
      final digits = value.replaceAll(RegExp(r'\D'), '');
      var target = index;
      for (var i = 0; i < digits.length && target < otpLength; i++) {
        _controllers[target].text = digits[i];
        target++;
      }
      final nextEmpty = _controllers.indexWhere((c) => c.text.isEmpty);
      final focusIndex = nextEmpty == -1 ? otpLength - 1 : nextEmpty;
      FocusScope.of(context).requestFocus(_focusNodes[focusIndex]);
      setState(() {});
      if (_code.length == otpLength) _submit();
      return;
    }

    setState(() {});

    if (value.isNotEmpty && index < otpLength - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
    if (_code.length == otpLength) _submit();
  }

  void _submit() {
    if (_isExpired) {
      AppSnackBar.error(context, context.l10n.otpExpiredNotice);
      return;
    }
    FocusScope.of(context).unfocus();
    context.read<PasswordResetCubit>().verifyOtp(_code);
  }

  void _onResend() {
    if (_secondsLeft > 0) return;
    context.read<PasswordResetCubit>().resendOtp();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final maxCardWidth = MediaQuery.of(context).size.width < 360 ? 300.0 : 340.0;

    return BlocListener<PasswordResetCubit, PasswordResetState>(
      listenWhen: (prev, curr) {
        _wasResendTransition = prev.isResending && !curr.isResending;
        return prev.isResending != curr.isResending ||
            (curr.isError && prev.message != curr.message);
      },
      listener: (context, state) {
        if (state.isError && state.message != null) {
          AppSnackBar.error(context, state.message!);
          if (!_wasResendTransition) {
            // A verify-otp failure (wrong/expired code) — let the user
            // retype. A failed *resend* leaves the current OTP/timers
            // untouched, since the still-valid code hasn't changed.
            _clearFields();
          }
        } else if (_wasResendTransition &&
            state.message != null &&
            !state.isError) {
          AppSnackBar.success(context, state.message!);
          _clearFields();
          _startCooldown();
          _startExpiryTimer();
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxCardWidth.w),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 24.r,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: BlocBuilder<PasswordResetCubit, PasswordResetState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ShieldIcon(),
                      SizedBox(height: 16.h),
                      Text(
                        strings.otpCardTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.lightPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.sp,
                            ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        strings.otpSentDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        maskEmail(state.email),
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: AppColors.lightPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _isExpired
                            ? strings.otpExpiredNotice
                            : '${strings.otpExpiresIn} ${_formatMmSs(_expirySecondsLeft)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isExpired ? AppColors.error : Colors.grey.shade600,
                          fontWeight: _isExpired ? FontWeight.w600 : FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      _OtpBoxesRow(
                        controllers: _controllers,
                        focusNodes: _focusNodes,
                        onChanged: _onBoxChanged,
                      ),
                      SizedBox(height: 18.h),
                      _ResendRow(secondsLeft: _secondsLeft, onResend: _onResend),
                      SizedBox(height: 22.h),
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: AppButton(
                          isLoading: state.phase == PasswordResetPhase.verifyingOtp,
                          isDisabled: _code.length != otpLength || _isExpired,
                          onPressed: _submit,
                          text: strings.confirmOtp,
                          backgroundColor: AppColors.orange,
                          textColor: AppColors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShieldIcon extends StatelessWidget {
  const _ShieldIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        IconsaxPlusBold.shield_tick,
        color: AppColors.primary,
        size: 28.sp,
      ),
    );
  }
}

class _OtpBoxesRow extends StatelessWidget {
  const _OtpBoxesRow({
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(int index, String value) onChanged;

  @override
  Widget build(BuildContext context) {
    // The OTP must always read digit1→digit6 left-to-right and be sent to
    // the API in that same order, regardless of the app's RTL layout —
    // otherwise the ambient RTL Directionality reverses the visual box
    // order relative to the controllers[0..5] index order used to build
    // the submitted otp string (see maskEmail's sibling bug report).
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(otpLength, (index) {
          return SizedBox(
            width: 42.w,
            height: 50.h,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controllers[index],
              builder: (context, value, _) {
                final isFilled = value.text.isNotEmpty;
                final isFocused = focusNodes[index].hasFocus;
                final borderColor = isFocused
                    ? AppColors.orange
                    : isFilled
                        ? AppColors.lightPrimary
                        : Colors.grey.shade300;

                return Focus(
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.backspace &&
                        controllers[index].text.isEmpty &&
                        index > 0) {
                      FocusScope.of(
                        context,
                      ).requestFocus(focusNodes[index - 1]);
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: TextField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: otpLength,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: borderColor, width: 1.6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          color: AppColors.orange,
                          width: 1.8,
                        ),
                      ),
                    ),
                    onChanged: (v) => onChanged(index, v),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow({required this.secondsLeft, required this.onResend});

  final int secondsLeft;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return BlocBuilder<PasswordResetCubit, PasswordResetState>(
      buildWhen: (prev, curr) => prev.isResending != curr.isResending,
      builder: (context, state) {
        if (state.isResending) {
          return SizedBox(
            height: 18.h,
            width: 18.h,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        }

        if (secondsLeft > 0) {
          return Text(
            '${strings.resendOtpIn} ${_formatMmSs(secondsLeft)}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp),
          );
        }

        return GestureDetector(
          onTap: onResend,
          child: Text(
            strings.resendOtp,
            style: TextStyle(
              color: AppColors.orange,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        );
      },
    );
  }
}
