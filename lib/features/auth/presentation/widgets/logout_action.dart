// مسؤول عن تنفيذ تسجيل الخروج الموحّد: التأكيد، إشعار الخادم، وتنظيف الجلسة محليًا.
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service/pusher_service.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

bool _isLoggingOut = false;

Future<void> confirmAndLogout(BuildContext context) async {
  if (_isLoggingOut) return;
  _isLoggingOut = true;

  try {
    final strings = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.logout),
        content: Text(strings.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(strings.logout),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final router = GoRouter.of(context);
    Scaffold.maybeOf(context)?.closeEndDrawer();

    await getIt<IAuthRepository>().logout();

    try {
      await PusherService().disconnect(intentional: true);
    } catch (_) {
      // A socket-close failure must never block clearing the local session.
    }

    await getIt<SecureStorage>().clearAuth();

    router.go(Routes.login);
  } finally {
    // Cancelled, unmounted, or an exception at any step — the lock must
    // never outlive this single attempt.
    _isLoggingOut = false;
  }
}
