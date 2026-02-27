import 'dart:io';

import 'package:car_care/core/errors/filuar.dart';
import 'package:dio/dio.dart';


class ServerExpcptions implements Exception {
  final Failure error;

  ServerExpcptions({required this.error});
}


void handelDioExcptions(DioException e) {
  Failure parseFiluar(dynamic data, String fallbackMessage) {
    try {
      if (data == null) return Failure(message: fallbackMessage);
      if (data is Map<String, dynamic>) return Failure.fromJson(data);
      if (data is String && data.isNotEmpty) return Failure(message: data);
      
      return Failure(message: fallbackMessage);
    } catch (_) {
      return Failure(message: fallbackMessage);
    }
  }

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerExpcptions(
          error: const Failure(message: "استغرق وقت طويل حاول مجدداً"));

    case DioExceptionType.sendTimeout:
      throw ServerExpcptions(
        error: parseFiluar(e.response?.data, "انتهت مهلة الإرسال، حاول مجدداً"),
      );

    case DioExceptionType.receiveTimeout:
      throw ServerExpcptions(
        error: parseFiluar(e.response?.data, "انتهت مهلة الاستلام، حاول مجدداً"),
      );

    case DioExceptionType.badCertificate:
      throw ServerExpcptions(
        error: parseFiluar(e.response?.data, "شهادة أمان غير صالحة"),
      );

    case DioExceptionType.cancel:
      throw ServerExpcptions(error: const Failure(message: "تم إلغاء الطلب"));

    case DioExceptionType.connectionError:
      if (e.error is SocketException) {
        throw ServerExpcptions(error: const Failure(message: "تحقق من اتصال الإنترنت"));
      } else {
        throw ServerExpcptions(error: Failure(message: e.message ?? "خطأ في الاتصال"));
      }

    case DioExceptionType.unknown:
     
      if (e.error is SocketException) {
        throw ServerExpcptions(error: const Failure(message: "لا يوجد اتصال بالشبكة"));
      }
      if (e.response != null) {
        throw ServerExpcptions(
            error: parseFiluar(e.response?.data, "حدث خطأ غير معروف"));
      }
      
      throw ServerExpcptions(error: Failure(message: e.message ?? "خطأ غير معروف"));

    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      final fallback = "خطأ في الاستجابة من الخادم (حالة: ${status ?? 'غير معروف'})";

      switch (status) {
        case 302:
        case 400:
        case 401:
        case 402:
        case 403:
        case 404:
        case 405:
        case 409:
        case 422:
        case 500:
        case 502:
        case 520:
          throw ServerExpcptions(error: parseFiluar(e.response?.data, fallback));
        default:
          throw ServerExpcptions(error: parseFiluar(e.response?.data, fallback));
      }
  }
}





