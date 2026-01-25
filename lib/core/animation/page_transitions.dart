// lib/core/animations/page_transitions.dart
import 'package:flutter/material.dart';

class PageTransitions {
  // ===== حركات الانتقال الأساسية =====

  /// تلاشي (Fade)
  static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  /// انزلاق من اليمين
  static Widget slideFromRight(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  /// انزلاق من الأسفل
  static Widget slideFromBottom(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  /// تكبير (Scale)
  static Widget scaleTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(scale: animation, child: child);
  }

  // ===== حركات خاصة بتطبيق المياه =====

  /// حركة "قطرة الماء" (خاصة بتطبيق قطرة)
  static Widget waterDropTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.elasticOut,
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  /// حركة "التموج" (مثل الماء)
  static Widget waveTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position:
          Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutBack,
            ),
          ),
      child: child,
    );
  }

  /// بدون حركة (لصفحات معينة)
  static Widget noTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
