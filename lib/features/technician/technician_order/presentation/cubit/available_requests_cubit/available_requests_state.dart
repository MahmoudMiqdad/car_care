


import 'package:car_care/features/technician/technician_order/domain/entities/available_requests_entity.dart';

abstract class AvailableRequestsState {
  const AvailableRequestsState();
}

class AvailableRequestsInitial extends AvailableRequestsState {}

class AvailableRequestsLoading extends AvailableRequestsState {}

class AvailableRequestsLoaded extends AvailableRequestsState {
  final AvailableRequestsEntity requests;

  AvailableRequestsLoaded(this.requests);
}

class AvailableRequestsError extends AvailableRequestsState {
  final String message;

  AvailableRequestsError(this.message);
}