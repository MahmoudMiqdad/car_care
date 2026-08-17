class ProviderProfileFuelPriceUiModel {
  const ProviderProfileFuelPriceUiModel({
    required this.fuelType,
    required this.apiValue,
    required this.price,
  });

  /// Display label shown to the user, e.g. "OCT 90".
  final String fuelType;

  /// Exact value sent to/received from the backend, e.g. "90".
  final String apiValue;
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
      ProviderProfileFuelPriceUiModel(fuelType: 'OCT 90', apiValue: '90', price: '10'),
      ProviderProfileFuelPriceUiModel(fuelType: 'OCT 95', apiValue: '95', price: '12'),
      ProviderProfileFuelPriceUiModel(fuelType: 'OCT 98', apiValue: '98', price: '13'),
    ],
  );
}
