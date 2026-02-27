import 'package:dio/dio.dart';

abstract class Failure {

  const Failure(this.errMessage);
  final String errMessage;
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with ApiServer');

      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with ApiServer');

      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with ApiServer');

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            dioError.response!.statusCode, dioError.response!.data,);
      case DioExceptionType.cancel:
        return ServerFailure('Request to ApiServer was canceled');

      case DioExceptionType.connectionError:
        if (dioError.message!.contains('SocketException')) {
          return ServerFailure('No Internet Connection');
        }
        return ServerFailure('Unexpected Error, Please try again!');
      default:
        return ServerFailure('Opps There was an Error, Please try again');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
  try {
    // لو response من نوع Map
    if (response is Map<String, dynamic>) {
      // لو السيرفر رجع errors
      if (response['errors'] != null) {
        final errors = response['errors'] as Map<String, dynamic>;
        // ناخد أول قيمة لأي حقل، مثلا 'email'
        final firstField = errors.keys.first;
        final firstMessage = (errors[firstField] as List).first;
        return ServerFailure(firstMessage.toString());
      }
      // أو ناخد message العام
      if (response['message'] != null) {
        return ServerFailure(response['message'].toString());
      }
    }

    // fallback
    return ServerFailure('حدث خطأ غير متوقع');
  } catch (e) {
    return ServerFailure('حدث خطأ غير متوقع');
  }
}
}
