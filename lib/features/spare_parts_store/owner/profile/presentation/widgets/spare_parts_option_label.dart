import 'package:car_care/features/spare_parts_store/owner/profile/data/static/spare_parts_options.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/widgets.dart';

typedef SparePartsOptionLabelBuilder =
    String Function(BuildContext context, SparePartsOption option);

String sparePartsOptionDefaultLabel(
  BuildContext context,
  SparePartsOption option,
) => option.name;

String sparePartsBusinessTypeLabel(
  BuildContext context,
  SparePartsOption option,
) {
  final l10n = context.l10n;
  return switch (option.id) {
    1 => l10n.sparePartsBusinessType1,
    2 => l10n.sparePartsBusinessType2,
    3 => l10n.sparePartsBusinessType3,
    4 => l10n.sparePartsBusinessType4,
    5 => l10n.sparePartsBusinessType5,
    6 => l10n.sparePartsBusinessType6,
    7 => l10n.sparePartsBusinessType7,
    8 => l10n.sparePartsBusinessType8,
    9 => l10n.sparePartsBusinessType9,
    10 => l10n.sparePartsBusinessType10,
    _ => option.name,
  };
}

String sparePartsPartCategoryLabel(
  BuildContext context,
  SparePartsOption option,
) {
  final l10n = context.l10n;
  return switch (option.id) {
    1 => l10n.sparePartsPartCategory1,
    2 => l10n.sparePartsPartCategory2,
    3 => l10n.sparePartsPartCategory3,
    4 => l10n.sparePartsPartCategory4,
    5 => l10n.sparePartsPartCategory5,
    6 => l10n.sparePartsPartCategory6,
    7 => l10n.sparePartsPartCategory7,
    8 => l10n.sparePartsPartCategory8,
    9 => l10n.sparePartsPartCategory9,
    10 => l10n.sparePartsPartCategory10,
    11 => l10n.sparePartsPartCategory11,
    12 => l10n.sparePartsPartCategory12,
    13 => l10n.sparePartsPartCategory13,
    14 => l10n.sparePartsPartCategory14,
    15 => l10n.sparePartsPartCategory15,
    16 => l10n.sparePartsPartCategory16,
    17 => l10n.sparePartsPartCategory17,
    18 => l10n.sparePartsPartCategory18,
    19 => l10n.sparePartsPartCategory19,
    20 => l10n.sparePartsPartCategory20,
    21 => l10n.sparePartsPartCategory21,
    22 => l10n.sparePartsPartCategory22,
    23 => l10n.sparePartsPartCategory23,
    _ => option.name,
  };
}
