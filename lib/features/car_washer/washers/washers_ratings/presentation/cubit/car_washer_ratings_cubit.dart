import 'package:car_care/features/car_washer/washers/washers_ratings/domain/repositories/i_car_washer_ratings_repository.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/presentation/cubit/car_washer_ratings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarWasherRatingsCubit extends Cubit<CarWasherRatingsState> {
  CarWasherRatingsCubit(this._repo) : super(CarWasherRatingsInitial());
  final ICarWasherRatingsRepository _repo;

  Future<void> fetchRatings(int carWasherId) async {
    if (state is CarWasherRatingsLoading) return; // no duplicate request

    emit(CarWasherRatingsLoading());
    final result = await _repo.getRatings(carWasherId, page: 1);

    result.fold(
      (failure) => emit(CarWasherRatingsError(failure.displayMessage)),
      (page) => emit(
        CarWasherRatingsLoaded(
          ratings: page.ratings,
          averageRating: page.averageRating,
          totalRatings: page.totalRatings,
          currentPage: page.currentPage,
          perPage: page.perPage,
        ),
      ),
    );
  }

  Future<void> loadMore(int carWasherId) async {
    final current = state;
    if (current is! CarWasherRatingsLoaded) return;
    if (current.isLoadingMore || !current.hasMore) return;

    emit(current.copyWith(isLoadingMore: true));
    final result = await _repo.getRatings(
      carWasherId,
      page: current.currentPage + 1,
    );

    result.fold(
      // Keeps the previously-loaded items visible; a failed "load more"
      // page simply stops the spinner instead of losing what's shown.
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (page) => emit(
        current.copyWith(
          ratings: [...current.ratings, ...page.ratings],
          averageRating: page.averageRating,
          totalRatings: page.totalRatings,
          currentPage: page.currentPage,
          perPage: page.perPage,
          isLoadingMore: false,
        ),
      ),
    );
  }
}
