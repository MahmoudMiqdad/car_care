import 'package:car_care/features/technician_sos/domain/entities/technician_sos_entity.dart';

abstract class TechnicianSosState {}

class TechnicianInitial extends TechnicianSosState {}

class TechnicianLoading extends TechnicianSosState {}

class TechnicianError extends TechnicianSosState {
  final String message;
  TechnicianError(this.message);
}

class TechnicianActionError extends TechnicianSosState {
  final String message;
  final TechnicianSosEntity? request;
  TechnicianActionError(this.message, {this.request});
}

class TechnicianAvailableLoaded extends TechnicianSosState {
  final List<TechnicianSosEntity> list;
  TechnicianAvailableLoaded(this.list);
}

class TechnicianRequestLoaded extends TechnicianSosState {
  final TechnicianSosEntity request;
  TechnicianRequestLoaded(this.request);
}

class TechnicianAccepted extends TechnicianSosState {
  final TechnicianSosEntity request;
  TechnicianAccepted(this.request);
}

class TechnicianStatusChanged extends TechnicianSosState {
  final TechnicianSosEntity request;
  TechnicianStatusChanged(this.request);
}

class TechnicianActionLoading extends TechnicianSosState {
  final int sosId;
  TechnicianActionLoading(this.sosId);
}

class TechnicianResponseCancelled extends TechnicianSosState {
  final String message;
  TechnicianResponseCancelled(this.message);
}

class TechnicianNavigateToMap extends TechnicianSosState {
  final TechnicianSosEntity request;
  TechnicianNavigateToMap(this.request);
}
