// مسؤول عن إدارة حالة تحميل الإعلانات حسب موضع عرضها.
import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';
import 'package:car_care/features/advertisements/domain/repositories/i_advertisement_repository.dart';
import 'package:car_care/features/advertisements/presentation/cubit/advertisement_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvertisementCubit extends Cubit<AdvertisementState> {
  AdvertisementCubit(this._repo) : super(AdvertisementInitial());

  final IAdvertisementRepository _repo;

  Future<void> loadAdvertisements(AdvertisementPlacement placement) async {
    emit(AdvertisementLoading());
    final res = await _repo.getActiveAdvertisements(placement);
    res.fold(
      (failure) => emit(AdvertisementError(failure.message)),
      (items) => emit(AdvertisementLoaded(items)),
    );
  }
}
