import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/i_ratings_repository.dart';
import 'ratings_state.dart';

class RatingsCubit extends Cubit<RatingsState> {
  RatingsCubit(this._repo) : super(RatingsInitial());

  final IRatingsRepository _repo;

  Future<void> submitRating({
    required int bookingId,
    required int rating,
    required String review,
  }) async {
    emit(RatingsLoading());

    final result = await _repo.submitRating(
      bookingId: bookingId,
      rating: rating,
      review: review,
    );

    result.fold(
      (failure) => emit(RatingsError(failure.message)),
      (data) => emit(RatingsSuccess(data, message: '')),
    );
  }
}
