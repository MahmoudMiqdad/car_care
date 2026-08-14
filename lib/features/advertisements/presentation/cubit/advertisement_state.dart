// مسؤول عن تمثيل حالات تحميل الإعلانات لكل موضع عرض.
import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';

abstract class AdvertisementState {}

class AdvertisementInitial extends AdvertisementState {}

class AdvertisementLoading extends AdvertisementState {}

class AdvertisementLoaded extends AdvertisementState {
  AdvertisementLoaded(this.items);
  final List<AdvertisementEntity> items;
}

class AdvertisementError extends AdvertisementState {
  AdvertisementError(this.message);
  final String message;
}
