import 'package:car_care/core/errors/failures.dart';
import 'package:dio/dio.dart';


class ErrorFailureInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {

    if (err.error is Failure) {
      return handler.next(err);
    }
    final failure = ServerFailure.fromDioError(err);
    handler.next(
      err.copyWith(error: failure),
    );
  }
}