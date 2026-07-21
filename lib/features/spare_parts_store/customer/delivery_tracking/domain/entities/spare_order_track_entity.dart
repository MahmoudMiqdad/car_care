// كيان تتبع طلب قطع الغيار في طبقة المجال.
class SpareOrderTrackEntity {
  final int? orderId;
  final String? orderStatus;
  final List<SpareTrackPointEntity> trackingPoints;
  final SpareTrackPointEntity? lastLocation;

  SpareOrderTrackEntity({
    this.orderId,
    this.orderStatus,
    required this.trackingPoints,
    this.lastLocation,
  });
}

class SpareTrackPointEntity {
  final double? latitude;
  final double? longitude;
  final String? timestamp;

  SpareTrackPointEntity({this.latitude, this.longitude, this.timestamp});
}
