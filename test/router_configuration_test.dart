// اختبار تكوين GoRouter لدفعة F0C: يمنع عودة الانهيار الناتج عن
// parentNavigatorKey مخالف داخل ShellRoute.routes. GoRouter يتحقق من شجرة
// المسارات في الـ constructor نفسه، قبل أي عرض للواجهة — لذلك مجرد الوصول
// إلى AppRouter.router يكفي لإعادة إنتاج الانهيار إن عاد الخطأ مستقبلاً.
import 'package:car_care/core/routing/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AppRouter.router builds without throwing an Assertion/Exception', () {
    expect(() => AppRouter.router, returnsNormally);
  });
}
