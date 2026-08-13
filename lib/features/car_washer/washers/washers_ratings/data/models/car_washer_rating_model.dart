import 'package:car_care/features/car_washer/washers/washers_ratings/domain/entities/car_washer_rating_entity.dart';

class CarWasherRatingModel extends CarWasherRatingEntity {
  const CarWasherRatingModel({
    required super.id,
    required super.rating,
    required super.ratingStars,
    required super.review,
    required super.userId,
    required super.userName,
    required super.createdAt,
    required super.createdAgo,
  });

  factory CarWasherRatingModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    return CarWasherRatingModel(
      id: _toInt(json['id']),
      rating: _toInt(json['rating']),
      ratingStars: (json['rating_stars'] ?? '').toString(),
      review: (json['review'] ?? '').toString(),
      userId: _toInt(user['id']),
      userName: (user['name'] ?? '').toString(),
      createdAt: (json['created_at'] ?? '').toString(),
      createdAgo: (json['created_ago'] ?? json['ago'] ?? '').toString(),
    );
  }

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}

class CarWasherRatingsPageModel {
  static CarWasherRatingsPageEntity fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    final ratings = rawList is List
        ? rawList
              .whereType<Map<String, dynamic>>()
              .map(CarWasherRatingModel.fromJson)
              .toList()
        : const <CarWasherRatingModel>[];

    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final currentPage = CarWasherRatingModel._toInt(meta['current_page']);
    final perPage = CarWasherRatingModel._toInt(meta['per_page']);

    return CarWasherRatingsPageEntity(
      ratings: ratings,
      averageRating: _toDouble(meta['average_rating']),
      totalRatings: CarWasherRatingModel._toInt(
        meta['total_ratings'] ?? meta['total'],
      ),
      currentPage: currentPage == 0 ? 1 : currentPage,
      perPage: perPage == 0 ? 15 : perPage,
    );
  }

  static double _toDouble(dynamic v) {
    if (v is double) return v;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }
}
