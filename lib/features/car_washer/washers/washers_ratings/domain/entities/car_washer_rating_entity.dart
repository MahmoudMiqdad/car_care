import 'package:equatable/equatable.dart';

class CarWasherRatingEntity extends Equatable {
  const CarWasherRatingEntity({
    required this.id,
    required this.rating,
    required this.ratingStars,
    required this.review,
    required this.userId,
    required this.userName,
    required this.createdAt,
    required this.createdAgo,
  });

  final int id;
  final int rating;
  final String ratingStars;
  final String review;
  final int userId;
  final String userName;
  final String createdAt;
  final String createdAgo;

  @override
  List<Object?> get props => [id, rating, review];
}

class CarWasherRatingsPageEntity extends Equatable {
  const CarWasherRatingsPageEntity({
    required this.ratings,
    required this.averageRating,
    required this.totalRatings,
    required this.currentPage,
    required this.perPage,
  });

  final List<CarWasherRatingEntity> ratings;
  final double averageRating;
  final int totalRatings;
  final int currentPage;
  final int perPage;

  bool get hasMore => currentPage * perPage < totalRatings;

  @override
  List<Object?> get props => [
    ratings,
    averageRating,
    totalRatings,
    currentPage,
    perPage,
  ];
}
