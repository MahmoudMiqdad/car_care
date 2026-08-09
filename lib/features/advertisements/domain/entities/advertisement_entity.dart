// مسؤول عن تمثيل بيانات الإعلان الفعّال القادمة من واجهة API.

enum AdvertisementPlacement {
  home,
  dashboard,
  service,
  general;

  String get apiValue => name;

  static AdvertisementPlacement? fromApiValue(String? value) {
    for (final placement in AdvertisementPlacement.values) {
      if (placement.apiValue == value) return placement;
    }
    return null;
  }
}

class AdvertisementEntity {
  const AdvertisementEntity({
    required this.id,
    required this.imageUrl,
    required this.placement,
    required this.sortOrder,
    this.title,
    this.linkUrl,
  });

  final int id;
  final String? title;
  final String imageUrl;
  final AdvertisementPlacement placement;
  final String? linkUrl;
  final int sortOrder;
}
