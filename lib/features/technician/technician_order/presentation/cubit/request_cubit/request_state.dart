
import 'package:car_care/features/technician/technician_order/domain/entities/request_entity.dart';



abstract class RequestState {
  const RequestState();
}

class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestLoaded extends RequestState {
  final RequestEntity request;

  RequestLoaded(this.request);
}

class RequestError extends RequestState {
  final String message;

  RequestError(this.message);
}