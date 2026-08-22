import 'package:car_care/features/vehicle/domain/entities/fuel_log_entity.dart';

abstract class FuelLogsState {
  const FuelLogsState();
}

class FuelLogsInitial extends FuelLogsState {
  const FuelLogsInitial();
}

class FuelLogsLoading extends FuelLogsState {
  const FuelLogsLoading();
}

class FuelLogsEmpty extends FuelLogsState {
  const FuelLogsEmpty();
}

class FuelLogsError extends FuelLogsState {
  const FuelLogsError(this.message);
  final String message;
}

class FuelLogsLoaded extends FuelLogsState {
  const FuelLogsLoaded({
    required this.items,
    required this.hasMore,
    required this.isLoadingMore,
  });

  final List<FuelLogEntity> items;
  final bool hasMore;

  final bool isLoadingMore;

  FuelLogsLoaded copyWith({
    List<FuelLogEntity>? items,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return FuelLogsLoaded(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
