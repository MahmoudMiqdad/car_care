import 'package:car_care/core/constants/list_province.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/selection/governorate_selection_tile.dart';
import 'package:car_care/core/widgets/selection/shared_selection_bottom_sheet.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/cubit/provider_profile_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/cubit/provider_profile_state.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/widgets/provider_edit_profile/provider_edit_profile_body.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/widgets/provider_edit_profile/provider_edit_profile_fuel_section.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProviderCreateProfilePage extends StatefulWidget {
  const ProviderCreateProfilePage({super.key});

  @override
  State<ProviderCreateProfilePage> createState() =>
      _ProviderCreateProfilePageState();
}

class _ProviderCreateProfilePageState
    extends State<ProviderCreateProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  String? _governorateValue;
  final Map<String, String> _fuelPrices = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickGovernorate() async {
    await SharedSelectionBottomSheet.show<String>(
      context: context,
      title: 'اختر المحافظة',
      items: kCreateSosProvinceOptions,
      itemBuilder: (context, e) => GovernorateSelectionTile(
        label: e,
        isSelected: _governorateValue == e,
      ),
      onSelected: (e) => setState(() => _governorateValue = e),
    );
  }

  Future<void> _onFuelTypeTap(String apiValue, String label) async {
    final price = await showProviderFuelPriceDialog(
      context,
      fuelType: label,
      initialPrice: _fuelPrices[apiValue],
    );
    if (!mounted || price == null) return;
    setState(() {
      if (price.isEmpty) {
        _fuelPrices.remove(apiValue);
      } else {
        _fuelPrices[apiValue] = price;
      }
    });
  }

  void _onCreate() {
    FocusScope.of(context).unfocus();

    final fuelTypes = _fuelPrices.keys.toList();
    final prices = _fuelPrices.map(
      (k, v) => MapEntry(k, double.tryParse(v) ?? 0.0),
    );

    context.read<FuelProviderProfileCubit>().addProfile({
      'company_name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'city': _governorateValue ?? '',
      'address': _addressController.text.trim(),
      'fuel_types': fuelTypes,
      'prices': prices,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: CustomAppBar(
        title: l10n.providerCreateProfilePageTitle,
        showBackButton: true,
        backgroundColor: AppColors.carWashTeal,
        onBackTapped: () => context.safePopOrGo(Routes.more),
      ),
      body: BlocListener<FuelProviderProfileCubit, FuelProviderProfileState>(
        listener: (context, state) {
          if (state is FuelProviderProfileLoaded) {
        
            context.go(Routes.provider_profile);
          }
          if (state is FuelProviderProfileError) {
            AppSnackBar.error(context, state.message);
          }
        },
        child: ImageBackground(
          child: ProviderEditProfileBody(
            nameController: _nameController,
            phoneController: _phoneController,
            addressController: _addressController,
            governorateValue: _governorateValue,
            onPickGovernorate: _pickGovernorate,
            fuelPrices: _fuelPrices,
            onSave: _onCreate,
            onCancel: () => context.safePopOrGo(Routes.more),
            saveLabel: l10n.providerCreateProfileSave,
            onFuelTypeTap: _onFuelTypeTap,
          ),
        ),
      ),
    );
  }
}