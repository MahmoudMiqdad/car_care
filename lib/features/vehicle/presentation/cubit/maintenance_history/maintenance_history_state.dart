import 'package:car_care/features/vehicle/domain/entities/maintenance_history_entry_entity.dart';

sealed class MaintenanceHistoryState {
  const MaintenanceHistoryState();
}

class MaintenanceHistoryInitial extends MaintenanceHistoryState {
  const MaintenanceHistoryInitial();
}

class MaintenanceHistoryLoading extends MaintenanceHistoryState {
  const MaintenanceHistoryLoading();
}

class MaintenanceHistorySuccess extends MaintenanceHistoryState {
  const MaintenanceHistorySuccess(this.items);
  final List<MaintenanceHistoryEntryEntity> items;
}

class MaintenanceHistoryFailure extends MaintenanceHistoryState {
  const MaintenanceHistoryFailure(this.message);
  final String message;
}