import 'package:car_care/features/car_washer/washers/domain/entities/washers_entity.dart';

abstract class WashersState {}

class WashersInitial extends WashersState {}

class WashersLoading extends WashersState {}

class WashersLoaded extends WashersState {
  WashersLoaded(this.items, {required this.cityQuery});

  final List<WasherEntity> items;
  final String cityQuery;
}

class WashersError extends WashersState {
  WashersError(this.message);

  final String message;
}