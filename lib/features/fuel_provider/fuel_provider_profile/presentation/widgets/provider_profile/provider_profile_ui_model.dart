class ProviderProfileFuelPriceUiModel {
  const ProviderProfileFuelPriceUiModel({
    required this.fuelType,
    required this.price,
  });

  final String fuelType;
  final String price;
}

class ProviderProfileUiModel {
  const ProviderProfileUiModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.isAvailable,
    required this.fuelPrices,
  });

  final String name;
  final String phone;
  final String address;
  final bool isAvailable;
  final List<ProviderProfileFuelPriceUiModel> fuelPrices;

  static Map<String, String> previewFuelPricesMap() {
    return {
      for (final item in preview.fuelPrices) item.fuelType: item.price,
    };
  }

  static const ProviderProfileUiModel preview = ProviderProfileUiModel(
    name: '',
    phone: '',
    address: '',
    isAvailable: true,
    fuelPrices: [
      ProviderProfileFuelPriceUiModel(fuelType: 'OCT 90', price: '10'),
      ProviderProfileFuelPriceUiModel(fuelType: 'OCT 95', price: '12'),
      ProviderProfileFuelPriceUiModel(fuelType: 'OCT 98', price: '13'),
    ],
  );
}
