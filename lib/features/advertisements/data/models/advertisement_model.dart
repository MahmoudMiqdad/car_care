// مسؤول عن تحويل بيانات الإعلان بين استجابة الخادم ونموذج التطبيق.
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';

class AdvertisementModel extends AdvertisementEntity {
  const AdvertisementModel({
    required super.id,
    required super.imageUrl,
    required super.placement,
    required super.sortOrder,
    super.title,
    super.linkUrl,
  });

  static bool _isValidImageUrl(String? value) {
    if (value == null || value.isEmpty) return false;
    final uri = Uri.tryParse(value);
    if (uri == null) return false;
    final scheme = uri.scheme.toLowerCase();
    return (scheme == 'http' || scheme == 'https') && uri.host.isNotEmpty;
  }

  static AdvertisementModel? fromJson(Map<String, dynamic> json) {
    final id = json['id'] is int
        ? json['id'] as int
        : int.tryParse(json['id']?.toString() ?? '');
    if (id == null) return null;

    final imageUrl = json['image_url']?.toString().trim();
    if (!_isValidImageUrl(imageUrl)) return null;

    final placement = AdvertisementPlacement.fromApiValue(
      json['placement']?.toString(),
    );
    if (placement == null) return null;

    final sortOrder = json['sort_order'] is int
        ? json['sort_order'] as int
        : int.tryParse(json['sort_order']?.toString() ?? '') ?? 0;

    final rawTitle = json['title']?.toString().trim();
    final rawLink = json['link_url']?.toString().trim();

    return AdvertisementModel(
      id: id,
      imageUrl: imageUrl!,
      placement: placement,
      sortOrder: sortOrder,
      title: (rawTitle == null || rawTitle.isEmpty) ? null : rawTitle,
      linkUrl: (rawLink == null || rawLink.isEmpty) ? null : rawLink,
    );
  }

  
  static List<AdvertisementModel> listFromResponse(
    Map<String, dynamic> response,
  ) {
    if (response['success'] != true) {
      throw ServerExpcptions(
        error: const Failure(message: 'تعذر تحميل الإعلانات'),
      );
    }

    final data = response['data'];
    if (data is! List) {
      throw ServerExpcptions(
        error: const Failure(message: 'تعذر تحميل الإعلانات'),
      );
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(AdvertisementModel.fromJson)
        .whereType<AdvertisementModel>()
        .toList();
  }
}
