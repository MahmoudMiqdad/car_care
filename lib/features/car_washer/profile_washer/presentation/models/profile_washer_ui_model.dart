import 'package:flutter/widgets.dart';

class ProfileWasherUiModel {
  const ProfileWasherUiModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.workStart,
    required this.workEnd,
    required this.description,
    required this.basicPrice,
    required this.vipPrice,
    required this.premiumPrice,
    this.avatarUrl,
    this.starFilledCount = 3,
    this.reviewCount = 507,
  });

  final String id;
  final String name;
  final String phone;
  final String address;
  final String workStart;
  final String workEnd;
  final String description;
  final String basicPrice;
  final String vipPrice;
  final String premiumPrice;
  final String? avatarUrl;
  final int starFilledCount;
  final int reviewCount;

  factory ProfileWasherUiModel.previewForLocale(Locale locale) {
    final isAr = locale.languageCode.toLowerCase().startsWith('ar');
    return ProfileWasherUiModel(
      id: 'washer-profile-ui-preview',
      name: 'مغسل المحبة',
      phone: '0987654321',
      workStart: '10:00',
      workEnd: '20:00',
      basicPrice: '10',
      vipPrice: '20',
      premiumPrice: '30',
      avatarUrl: null,
      starFilledCount: 3,
      reviewCount: 507,
      address: isAr
          ? 'دمشق - ساحة العباسيين - مدخل ساحة القصور'
          : 'Damascus - Abbasiyyin Square - Entrance to Al-Qusour Square',
      description: isAr
          ? 'في مغسل المحبة نوفّر لكم غسيلاً احترافياً للسيارات بمنتجات آمنة وصديقة للبيئة، مع فريق يهتم بتفاصيل السيارة من الخارج إلى الداخل. نسعى لخدمتكم يوماً بعد يوم بأسعار واضحة ووقت انتظار مريح، لتشعرون أن سيارتكم في عناية ناس بتحب الشغل النظيف.'
          : 'At Mahaba Car Wash we deliver professional cleaning with safe, eco-friendly products and a crew that cares about every detail, inside and out. We strive to serve you day after day with clear pricing and a comfortable wait—because your car deserves spotless care from people who love doing the job right.',
    );
  }
}
