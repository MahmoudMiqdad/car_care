import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:car_care/core/service/pusher_service.dart';
import 'package:car_care/features/sos/domain/repositories/i_sos_repository.dart';
import 'package:car_care/features/sos/presentation/cubit/tracking_cubit/tracking_state.dart';
import 'package:latlong2/latlong.dart';

class TrackingCubit extends Cubit<TrackingState> {
  final ISosRepository _repo;
  final PusherService _pusher;

  int? _currentSosId;
  bool _isSubscribed = false;
  bool _isFetching = false;

  Timer? _pollingTimer;

  TrackingCubit(this._repo, this._pusher) : super(TrackingInitial());

  // LOAD 
  Future<void> loadTracking(int sosId) async {
    _currentSosId = sosId;

    if (_isFetching) return;
    _isFetching = true;

    emit(TrackingLoading());

    final res = await _repo.trackSos(sosId);

    res.fold(
      (failure) {
        _isFetching = false;

        if (failure.message.contains('لم يتم تعيين فني بعد')) {
          emit(TrackingWaitingTechnician());

          _startPolling(sosId);
          return;
        }

        emit(TrackingError(failure.message));
      },
      (data) async {
        _isFetching = false;

        emit(TrackingLoaded(data));

        _stopPolling(); // وقف الـ polling عند النجاح

        if (!_isSubscribed) {
          _isSubscribed = true;

          await _pusher.subscribeToSosTracking(
            sosId: sosId,
            onLocationUpdate: (lat, lng) {
              final current = state;

              if (current is TrackingLoaded) {
                emit(
                  current.copyWith(
                    liveLocation: LatLng(lat, lng),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  //  POLLING
  void _startPolling(int sosId) {
    _stopPolling();

    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        if (_currentSosId == sosId) {
          loadTracking(sosId);
        }
      },
    );
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  // CLOSE 
  @override
  Future<void> close() async {
    _stopPolling();

    if (_currentSosId != null) {
      await _pusher.unsubscribeFromSos(_currentSosId!);
    }

    return super.close();
  }
}