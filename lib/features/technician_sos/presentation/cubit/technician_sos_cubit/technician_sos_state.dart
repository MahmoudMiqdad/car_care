import 'package:car_care/features/technician_sos/domain/entities/technician_sos_entity.dart';

abstract class TechnicianSosState {}

class TechnicianInitial extends TechnicianSosState {}

class TechnicianLoading extends TechnicianSosState {}

class TechnicianError extends TechnicianSosState {
  final String message;
  TechnicianError(this.message);
}

/// Emitted when an accept/status/cancel action fails while a list/details
/// screen is already showing data, so the UI can surface a snackbar
/// without replacing that content with a full-page error state.
/// [request] carries the last successfully loaded SOS details (if any), so
/// the details page can keep rendering them instead of going blank.
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

/// Emitted while a status/cancel action is in flight, so the list keeps
/// showing its items instead of collapsing to a full-page loader.
class TechnicianActionLoading extends TechnicianSosState {
  final int sosId;
  TechnicianActionLoading(this.sosId);
}

/// Technician cancelled their own response; backend reopened the request.
class TechnicianResponseCancelled extends TechnicianSosState {
  final String message;
  TechnicianResponseCancelled(this.message);
}
class TechnicianNavigateToMap extends TechnicianSosState {
  final TechnicianSosEntity request;
  TechnicianNavigateToMap(this.request);
}