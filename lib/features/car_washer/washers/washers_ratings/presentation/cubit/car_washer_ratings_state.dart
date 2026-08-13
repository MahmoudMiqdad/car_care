import 'package:car_care/features/car_washer/washers/washers_ratings/domain/entities/car_washer_rating_entity.dart';

abstract class CarWasherRatingsState {}

class CarWasherRatingsInitial extends CarWasherRatingsState {}

class CarWasherRatingsLoading extends CarWasherRatingsState {}

/// Also covers the empty case — an empty [ratings] list is a legitimate,
/// well-formed result; `average`/`total` still come from `meta` and are
/// never derived from the list itself.
class CarWasherRatingsLoaded extends CarWasherRatingsState {
  CarWasherRatingsLoaded({
    required this.ratings,
    required this.averageRating,
    required this.totalRatings,
    required this.currentPage,
    required this.perPage,
    this.isLoadingMore = false,
  });

  final List<CarWasherRatingEntity> ratings;
  final double averageRating;
  final int totalRatings;
  final int currentPage;
  final int perPage;
  final bool isLoadingMore;

  bool get hasMore => currentPage * perPage < totalRatings;

  CarWasherRatingsLoaded copyWith({
    List<CarWasherRatingEntity>? ratings,
    double? averageRating,
    int? totalRatings,
    int? currentPage,
    int? perPage,
    bool? isLoadingMore,
  }) {
    return CarWasherRatingsLoaded(
      ratings: ratings ?? this.ratings,
      averageRating: averageRating ?? this.averageRating,
      totalRatings: totalRatings ?? this.totalRatings,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CarWasherRatingsError extends CarWasherRatingsState {
  CarWasherRatingsError(this.message);
  final String message;
}
