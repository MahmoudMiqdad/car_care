import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:flutter/widgets.dart';

String localizeErrorMessage(BuildContext context, String? rawMessage) {
  final message = rawMessage?.trim() ?? '';
  final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
  if (l10n == null) return message;

  if (message.isEmpty || message.startsWith('Instance of')) {
    return l10n.genericErrorTryAgain;
  }

  final lower = message.toLowerCase();

  if (lower.contains('dioexception') ||
      lower.contains('socketexception') ||
      lower.contains('timeoutexception') ||
      lower.contains('formatexception') ||
      lower.contains('httpexception') ||
      lower.contains('sqlstate') ||
      lower.contains('stack trace') ||
      lower.startsWith('exception:')) {
    return l10n.genericErrorTryAgain;
  }

  if (message == 'لا يوجد اتصال بالشبكة' ||
      message == 'تحقق من اتصال الإنترنت' ||
      lower.contains('failed host lookup') ||
      lower.contains('network is unreachable')) {
    return l10n.noInternetConnection;
  }

  if (message == 'استغرق وقت طويل حاول مجدداً' ||
      message == 'انتهت مهلة الإرسال، حاول مجدداً' ||
      message == 'انتهت مهلة الاستلام، حاول مجدداً' ||
      lower.contains('connection timed out') ||
      lower.contains('connect timeout') ||
      lower.contains('receive timeout') ||
      lower.contains('send timeout')) {
    return l10n.connectionTimeoutError;
  }

  if ((message.contains('خطأ في الاستجابة من الخادم') &&
          message.contains('401')) ||
      lower.contains('unauthenticated') ||
      lower == 'unauthorized' ||
      lower == 'unauthorized.') {
    return l10n.sessionExpiredError;
  }

  if (message.contains('خطأ في الاستجابة من الخادم') ||
      message == 'خطأ في الاتصال' ||
      message == 'حدث خطأ غير معروف' ||
      message == 'خطأ غير معروف' ||
      message == 'شهادة أمان غير صالحة' ||
      message == 'تم إلغاء الطلب') {
    return l10n.serverError;
  }

  if (message == 'حدث خطأ غير متوقع' ||
      message == 'حدث خطأ أثناء تنفيذ العملية، حاول مرة أخرى') {
    return l10n.genericErrorTryAgain;
  }

  if (message == 'Email أو كلمة المرور غير صحيحة') {
    return l10n.invalidCredentialsError;
  }

  if (message == 'حدث خطأ أثناء التسجيل، تحقق من البيانات') {
    return l10n.registrationFailedError;
  }

  if (message == 'تعذر تسجيل الدخول عبر Google') {
    return l10n.googleSignInFailedError;
  }

  if (message.contains('حدث خطأ') || message.contains('تعذر')) {
    if (message.contains('جلب') || message.contains('تحميل')) {
      return l10n.failedToLoadData;
    }
    if (message.contains('حفظ') || message.contains('رفع')) {
      return l10n.failedToSaveChanges;
    }
    if (message.contains('إلغاء')) {
      return l10n.failedToCancel;
    }
    if (message.contains('تحديث') || message.contains('تعديل')) {
      return l10n.failedToUpdate;
    }
    if (message.contains('حذف')) {
      return l10n.failedToDelete;
    }
    if (message.contains('إضافة') || message.contains('إنشاء')) {
      return l10n.failedToCreate;
    }
    if (message.contains('قبول')) {
      return l10n.failedToAccept;
    }
    if (message.contains('رفض')) {
      return l10n.failedToReject;
    }
    if (message.contains('إرسال')) {
      return l10n.failedToSubmit;
    }
  }

  return message;
}
