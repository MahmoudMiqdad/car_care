import 'package:equatable/equatable.dart';

class CarWashCustomerReview extends Equatable {
  const CarWashCustomerReview({
    required this.authorName,
    required this.date,
    required this.comment,
    required this.stars,
  });

  final String authorName;
  final DateTime date;
  final String comment;
  final double stars;

  @override
  List<Object?> get props => <Object?>[authorName, date, comment, stars];
}
