// بيانات الخيارات المحلية لملف متجر المالك.
class SparePartsOption {
  const SparePartsOption(this.id, this.name);

  final int id;
  final String name;
}

class SparePartsOptions {
  SparePartsOptions._();

  static const List<SparePartsOption> businessTypes = [
    SparePartsOption(1, 'قطع غيار مستعملة/كسر'),
    SparePartsOption(2, 'إطارات وجنطات'),
    SparePartsOption(3, 'قطع غيار جديدة'),
    SparePartsOption(4, 'بطاريات وزيوت'),
    SparePartsOption(5, 'اكسسوارات وزينة'),
    SparePartsOption(6, 'زيوت وفلاتر'),
    SparePartsOption(7, 'كهرباء سيارات'),
    SparePartsOption(8, 'قطع بودي وهيكل'),
    SparePartsOption(9, 'قطع محركات'),
    SparePartsOption(10, 'خدمات تشليح'),
  ];

  static const List<SparePartsOption> carBrands = [
    SparePartsOption(1, 'Toyota'),
    SparePartsOption(2, 'Hyundai'),
    SparePartsOption(3, 'Mercedes-Benz'),
    SparePartsOption(4, 'Kia'),
    SparePartsOption(5, 'BMW'),
    SparePartsOption(6, 'Chevrolet'),
    SparePartsOption(7, 'Volkswagen'),
    SparePartsOption(8, 'Mazda'),
    SparePartsOption(9, 'Nissan'),
    SparePartsOption(10, 'Honda'),
    SparePartsOption(11, 'Ford'),
    SparePartsOption(12, 'Mitsubishi'),
    SparePartsOption(13, 'Suzuki'),
    SparePartsOption(14, 'Renault'),
    SparePartsOption(15, 'Peugeot'),
    SparePartsOption(16, 'Audi'),
    SparePartsOption(17, 'Lexus'),
    SparePartsOption(18, 'Jeep'),
    SparePartsOption(19, 'GMC'),
    SparePartsOption(20, 'Opel'),
  ];

  static const List<SparePartsOption> partCategories = [
    SparePartsOption(1, 'فرامل وديسكات'),
    SparePartsOption(2, 'غماشة وركسين'),
    SparePartsOption(3, 'هيكل خارجي وصاج'),
    SparePartsOption(4, 'ميكانيك عام'),
    SparePartsOption(5, 'كهرباء ونظام إنارة'),
    SparePartsOption(6, 'فلتر وبواجي'),
    SparePartsOption(7, 'محرك وقطع داخلية'),
    SparePartsOption(8, 'قير وناقل حركة'),
    SparePartsOption(9, 'تبريد وراديتر'),
    SparePartsOption(10, 'تعليق ومساعدات'),
    SparePartsOption(11, 'إطارات وجنوط'),
    SparePartsOption(12, 'زيوت وسوائل'),
    SparePartsOption(13, 'بطاريات'),
    SparePartsOption(14, 'حساسات وكمبيوتر'),
    SparePartsOption(15, 'مرايا وزجاج'),
    SparePartsOption(16, 'أنظمة عادم'),
    SparePartsOption(17, 'داخلية واكسسوارات'),
    SparePartsOption(18, 'مصابيح وإنارة'),
    SparePartsOption(19, 'مكيف وتبريد'),
    SparePartsOption(20, 'أبواب وأقفال'),
    SparePartsOption(21, 'مقود وتعليق'),
    SparePartsOption(22, 'طرمبات وفلاتر'),
    SparePartsOption(23, 'سيور وبكرات'),
  ];

  static SparePartsOption? findById(List<SparePartsOption> lookup, int id) =>
      lookup.where((o) => o.id == id).firstOrNull;

  static SparePartsOption? findByName(
    List<SparePartsOption> lookup,
    String name,
  ) =>
      lookup.where((o) => o.name == name).firstOrNull;

  static List<int> namesToIds(
    List<SparePartsOption> lookup,
    List<String> names,
  ) =>
      names
          .map((n) => findByName(lookup, n))
          .whereType<SparePartsOption>()
          .map((o) => o.id)
          .toList();

  static ({List<int> ids, List<String> unknown}) namesToIdsChecked(
    List<SparePartsOption> lookup,
    List<String> names,
  ) {
    final ids = <int>[];
    final unknown = <String>[];
    for (final n in names) {
      final opt = findByName(lookup, n);
      if (opt != null) {
        ids.add(opt.id);
      } else {
        unknown.add(n);
      }
    }
    return (ids: ids, unknown: unknown);
  }

  static List<String> idsToNames(
    List<SparePartsOption> lookup,
    List<int> ids,
  ) =>
      ids
          .map((id) => findById(lookup, id))
          .whereType<SparePartsOption>()
          .map((o) => o.name)
          .toList();
}