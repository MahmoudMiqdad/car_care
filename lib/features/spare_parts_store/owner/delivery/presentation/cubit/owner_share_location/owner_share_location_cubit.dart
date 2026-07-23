// كيوبت إرسال موقع المالك — استدعاء منفرد لكل تحديث يُطلق من الخريطة.
import 'package:car_care/features/spare_parts_store/owner/delivery/domain/repositories/i_owner_share_location_repository.dart';
import 'package:car_care/features/spare_parts_store/owner/delivery/presentation/cubit/owner_share_location/owner_share_location_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerShareLocationCubit extends Cubit<OwnerShareLocationState> {
  final IOwnerShareLocationRepository _repo;
  OwnerShareLocationCubit(this._repo) : super(OwnerShareLocationInitial());

  Future<void> shareLocation({
    required int orderId,
    required double lat,
    required double lng,
  }) async {
    emit(OwnerShareLocationLoading());
    final res = await _repo.shareLocation(orderId: orderId, lat: lat, lng: lng);
    res.fold(
      (l) => emit(OwnerShareLocationError(l.message)),
      (_) => emit(OwnerShareLocationSuccess()),
    );
  }
}
