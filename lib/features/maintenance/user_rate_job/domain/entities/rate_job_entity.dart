class RateJobEntity {
  final bool success;
  final String message;
  final RateDataEntity data;

  RateJobEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}

class RateDataEntity {
  final int id;
  final int rating;
  final String review;

  RateDataEntity({
    required this.id,
    required this.rating,
    required this.review,
  });
}