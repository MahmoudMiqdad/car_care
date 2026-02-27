
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:dio/dio.dart';

class ErrorFailureInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      
      if (err.error is Failure) {
        return handler.next(err);
      }

     
      handelDioExcptions(err);

    } on ServerExpcptions catch (e) {
      
      handler.next(
        err.copyWith(error: e.error),
      );
    } catch (_) {
      handler.next(
        err.copyWith(
          error: const Failure(message: "حدث خطأ غير متوقع"),
        ),
      );
    }
  }
}