// نموذج بيانات تتبع طلب قطع الغيار — يحلّل استجابة API.
class SpareOrderTrackModel {
  final bool? success;
  final SpareOrderTrackData? data;

  SpareOrderTrackModel({this.success, this.data});

  factory SpareOrderTrackModel.fromJson(Map<String, dynamic> json) =>
      SpareOrderTrackModel(
        success: json['success'],
        data: json['data'] != null
            ? SpareOrderTrackData.fromJson(json['data'])
            : null,
      );
}

class SpareOrderTrackData {
  final int? orderId;
  final String? orderStatus;
  final List<SpareTrackPoint> trackingPoints;
  final SpareTrackPoint? lastLocation;

  SpareOrderTrackData({
    this.orderId,
    this.orderStatus,
    required this.trackingPoints,
    this.lastLocation,
  });

  factory SpareOrderTrackData.fromJson(Map<String, dynamic> json) =>
      SpareOrderTrackData(
        orderId: json['order_id'],
        orderStatus: json['order_status'],
        trackingPoints: json['tracking_points'] != null
            ? List.from(json['tracking_points'])
                .map((e) => SpareTrackPoint.fromJson(e))
                .toList()
            : [],
        lastLocation: json['last_location'] != null
            ? SpareTrackPoint.fromJson(json['last_location'])
            : null,
      );
}

class SpareTrackPoint {
  final double? latitude;
  final double? longitude;
  final String? timestamp;

  SpareTrackPoint({this.latitude, this.longitude, this.timestamp});

  factory SpareTrackPoint.fromJson(Map<String, dynamic> json) =>
      SpareTrackPoint(
        latitude: double.tryParse(
            (json['latitude'] ?? json['lat'] ?? '').toString()),
        longitude: double.tryParse(
            (json['longitude'] ?? json['lng'] ?? '').toString()),
        timestamp: json['timestamp'] ?? json['last_updated'],
      );
}
