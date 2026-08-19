import 'package:car_care/core/constants/list_province.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/sos/presentation/cubit/sos_cubit/sos_cubit.dart';
import 'package:car_care/features/sos/presentation/cubit/sos_cubit/sos_state.dart';
import 'package:car_care/features/sos/presentation/widgets/create_sos/create_sos_body.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';

class CreateSosPage extends StatefulWidget {
  const CreateSosPage({super.key});

  @override
  State<CreateSosPage> createState() => _CreateSosPageState();
}

class _CreateSosPageState extends State<CreateSosPage> {
  late final TextEditingController _descriptionController;

  String _vehicleValue = '';
  String _provinceValue = '';
  VehicleEntity? _selectedVehicle;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();

    Future.microtask(() {
      if (mounted) context.read<VehicleCubit>().getAllVehicles();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickVehicle() async {
    final l10n = context.l10n;
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
    AppSnackBar.error(context, l10n.noVehiclesAdded);
      return;
    }

    if (state is! VehicleLoaded) return;

    final vehicles = state.vehicles;

    FocusScope.of(context).unfocus();

    final choice = await showModalBottomSheet<VehicleEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
            ),
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: vehicles.length > 4 ? 0.5 : 0.35,
              minChildSize: 0.25,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return ListView(
                  controller: scrollController,
                  children: vehicles.map((v) {
                    final isSelected = _selectedVehicle?.id == v.id;
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: AppColors.cardBackground(context),
                        backgroundImage: v.image != null && v.image!.isNotEmpty
                            ? NetworkImage(v.image!)
                            : null,
                        child: v.image == null || v.image!.isEmpty
                            ? Icon(Icons.directions_car, size: 18.sp, color: AppColors.primary)
                            : null,
                      ),
                      title: Text('${v.brand} ${v.model}'),
                      subtitle: Text('${v.year} • ${v.plateNumber}'),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                            )
                          : null,
                      selected: isSelected,
                      onTap: () => Navigator.pop(context, v),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        );
      },
    );

    if (!mounted) return;

    if (choice != null) {
      setState(() {
        _selectedVehicle = choice;
        _vehicleValue = '${choice.brand} ${choice.model}';
      });
    }
  }

  Future<void> _pickProvince() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
            ),
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
          ),
        );
      },
    );

    if (!mounted) return;

    if (choice != null) {
      setState(() => _provinceValue = choice);
    }
  }

  Future<void> _onSubmit() async {
    final l10n = context.l10n;
    FocusScope.of(context).unfocus();

    if (_selectedVehicle == null) {
    AppSnackBar.error(context, l10n.washerSelectVehicleMessage);
      return;
    }

    if (_provinceValue.isEmpty) {
    AppSnackBar.error(context, l10n.washerSelectProvinceMessage);
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
     AppSnackBar.error(context, l10n.pleaseEnterRejectionReason);
      return;
    }

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;

      AppSnackBar.error(context, l10n.enableLocationPrompt);
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      if (!mounted) return;

      context.read<SosCubit>().createSos({
        'vehicle_id': _selectedVehicle!.id,
        'lat': position.latitude,
        'lng': position.longitude,
        'description': _descriptionController.text.trim(),
        'city': _provinceValue,
      });
    } catch (e) {
      if (!mounted) return;

    AppSnackBar.error(context, '${l10n.locationErrorPrefix}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<SosCubit, SosState>(
      listener: (context, state) {
        if (state is SosCreated) {
          final sos = state.sos;
          final id = sos.id;

       AppSnackBar.success(context, l10n.requestSentSuccess);

          if (id != null) {
            context.pushReplacementNamed(
              'sosDetails',
              pathParameters: {'id': id.toString()},
            );
          } else {
            context.safePopOrGo(Routes.allUserSosRequests);
          }
        }

        if (state is SosError) {
          AppSnackBar.error(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        appBar: CustomAppBar(
          title: l10n.createSosTitle,
          showBackButton: true,
          onBackTapped: () => context.safePopOrGo(Routes.home),
        ),
        body: ImageBackground(
          child: BlocBuilder<SosCubit, SosState>(
            builder: (context, state) {
              return CreateSosBody(
                descriptionController: _descriptionController,
                vehicleValue: _vehicleValue,
                provinceValue: _provinceValue,
                onPickVehicle: _pickVehicle,
                onPickProvince: _pickProvince,
                onSubmit: _onSubmit,
                isLoading: state is SosLoading,
              );
            },
          ),
        ),
      ),
    );
  }
}
