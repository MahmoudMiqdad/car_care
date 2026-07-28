import 'package:car_care/core/constants/list_province.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_cubit.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_state.dart';
import 'package:car_care/features/user_fuel/presentation/widgets/fuel_sos_create/fuel_sos_create_body.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FuelSosCreatePage extends StatefulWidget {
  const FuelSosCreatePage({super.key});

  @override
  State<FuelSosCreatePage> createState() => _FuelSosCreatePageState();
}

class _FuelSosCreatePageState extends State<FuelSosCreatePage> {
  late final TextEditingController _quantityController;
  late final TextEditingController _notesController;

  String? _vehicleValue;
  int? _vehicleId;
  String? _fuelTypeValue;
  String? _provinceValue;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickVehicle() async {
    final cubit = context.read<VehicleCubit>();
    var state = cubit.state;

    if (state is VehicleLoading) {
      await cubit.stream.firstWhere((s) => s is! VehicleLoading);
    }

    if (!mounted) return;
    state = cubit.state;

    if (state is VehicleError) {
      AppSnackBar.error(context, state.message);
      return;
    }

    if (state is VehicleEmpty) {
      AppSnackBar.error(context, 'لا توجد سيارات مضافة');
      return;
    }

    if (state is! VehicleLoaded) return;

    final vehicles = state.vehicles;

    final choice = await showModalBottomSheet<VehicleEntity>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: vehicles.map((v) {
            return ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: v.image != null && v.image!.isNotEmpty
                    ? NetworkImage(v.image!)
                    : null,
                child: v.image == null || v.image!.isEmpty
                    ? const Icon(Icons.directions_car, size: 18)
                    : null,
              ),
              title: Text('${v.brand} ${v.model}'),
              subtitle: Text('${v.year} • ${v.plateNumber}'),
              onTap: () => Navigator.pop(context, v),
            );
          }).toList(),
        );
      },
    );

    if (!mounted || choice == null) return;
    setState(() {
      _vehicleValue = '${choice.brand} ${choice.model}';
      _vehicleId = choice.id;
    });
  }

  Future<void> _pickFuelType() async {
    final l10n = context.l10n;
    final options = [l10n.gasoline91, l10n.gasoline95, l10n.diesel];

    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((e) {
            return ListTile(
              title: Text(e),
              onTap: () => Navigator.pop(context, e),
            );
          }).toList(),
        );
      },
    );

    if (!mounted || choice == null) return;
    setState(() => _fuelTypeValue = choice);
  }

  Future<void> _pickProvince() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: kCreateSosProvinceOptions.map((e) {
                  return ListTile(
                    title: Text(e),
                    onTap: () => Navigator.pop(context, e),
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );

    if (!mounted || choice == null) return;
    setState(() => _provinceValue = choice);
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    final l10n = context.l10n;

    if (_vehicleId == null ||
        _fuelTypeValue == null ||
        _quantityController.text.isEmpty ||
        _provinceValue == null) {
      AppSnackBar.error(context, 'من فضلك أكمل جميع الحقول');
      return;
    }

    String fuelTypeApiValue;
    if (_fuelTypeValue == l10n.gasoline91) {
      fuelTypeApiValue = '91';
    } else if (_fuelTypeValue == l10n.gasoline95) {
      fuelTypeApiValue = '95';
    } else {
      fuelTypeApiValue = 'diesel';
    }

    context.read<UserFuelCubit>().addEmergencyOrder({
      'vehicle_id': _vehicleId,
      'fuel_type': fuelTypeApiValue,
      'amount': double.tryParse(_quantityController.text) ?? 0,
      'delivery_latitude': 24.7136,
      'delivery_longitude': 46.6753,
      'city': _provinceValue,
      'notes': _notesController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(
          title: l10n.fuelSosCreateTitle,
          showBackButton: true,
          onBackTapped: () => context.safePopOrGo(Routes.home),
        ),
        body: BlocListener<UserFuelCubit, UserFuelState>(
          listener: (context, state) {
            if (state is UserFuelOrderCreated) {
              AppSnackBar.success(context, 'تم إرسال طلب الوقود بنجاح');
        
            }
            if (state is UserFuelError) {
              AppSnackBar.error(context, state.message);
            }
          },
          child: ImageBackground(
            child: FuelSosCreateBody(
              vehicleValue: _vehicleValue,
              fuelTypeValue: _fuelTypeValue,
              provinceValue: _provinceValue,
              quantityController: _quantityController,
              notesController: _notesController,
              onPickVehicle: _pickVehicle,
              onPickFuelType: _pickFuelType,
              onPickProvince: _pickProvince,
              onSubmit: _onSubmit,
            ),
          ),
        ),
      ),
    );
  }
}