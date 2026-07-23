class ProviderOrderUiModel {
  const ProviderOrderUiModel({
    required this.address,
    required this.fuel,
    required this.price,
    required this.dateTime,
  });

  final String address;
  final String fuel;
  final String price;
  final String dateTime;

  static const ProviderOrderUiModel preview = ProviderOrderUiModel(
    address: 'دمشق - ساحة العباسيين - مدخل ساحة القصور',
    fuel: 'OCT 98 / 50L',
    price: '\$99',
    dateTime: '12/12/2026 - 7:55 PM',
  );

  static const List<ProviderOrderUiModel> previewList = [
    preview,
    preview,
  ];
}
