import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care/features/car_washer/washers/domain/repositories/i_washers_repository.dart';
import 'washers_state.dart';

class WashersCubit extends Cubit<WashersState> {
  WashersCubit(this._repository) : super(WashersInitial());

  final IWashersRepository _repository;

  Timer? _debounce;
  String _cityQuery = '';

  String get cityQuery => _cityQuery;

  Future<void> fetchWashers({String? city}) async {
    final query = (city ?? _cityQuery).trim();
    _cityQuery = query;

    emit(WashersLoading());

    final result = await _repository.getWashers(
      city: query.isEmpty ? null : query,
    );

    result.fold(
      (failure) => emit(WashersError(failure.message)),
      (items) => emit(WashersLoaded(items, cityQuery: _cityQuery)),
    );
  }

  void onCityChanged(String value) {
    _cityQuery = value;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchWashers(city: _cityQuery);
    });
  }

  void clearCity() {
    _cityQuery = '';
    fetchWashers(city: null);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}