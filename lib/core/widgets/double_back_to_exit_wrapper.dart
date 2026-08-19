import 'dart:async';

import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// يلف صفحة الجذر (Home) بس. لما المستخدم يضغط زر رجوع الجوال وهو واقف
/// عالتاب الرئيسي، بدل ما يطلع من التطبيق فورًا، بيطلعله تنبيه، وإذا ضغط
/// رجوع مرة تانية خلال ثانيتين فعليًا بيسكر التطبيق.
class DoubleBackToExitWrapper extends StatefulWidget {
  const DoubleBackToExitWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<DoubleBackToExitWrapper> createState() =>
      _DoubleBackToExitWrapperState();
}

class _DoubleBackToExitWrapperState extends State<DoubleBackToExitWrapper> {
  DateTime? _lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final now = DateTime.now();
        final canWarnAgain = _lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2);

        if (canWarnAgain) {
          _lastBackPressTime = now;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(context.l10n.pressBackAgainToExit),
                duration: const Duration(seconds: 2),
              ),
            );
        } else {
          SystemNavigator.pop();
        }
      },
      child: widget.child,
    );
  }
}
