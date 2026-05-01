import 'package:equatable/equatable.dart';

class CarWashBookingEntity extends Equatable {
  const CarWashBookingEntity({
    required this.success,
    required this.message,
    required this.id,
    required this.serviceType,
    required this.statusText,
    required this.scheduledAt,
    required this.canCancel,
  });

  final bool success;
  final String message;

  final int id;
  final String serviceType;
  final String statusText;
  final String scheduledAt;
  final bool canCancel;

  @override
  List<Object?> get props => [
        success,
        message,
        id,
        serviceType,
        statusText,
        scheduledAt,
        canCancel,
      ];
}