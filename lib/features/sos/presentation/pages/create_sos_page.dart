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
    final cubit = context.read<VehicleCubit>();
    var state = cubit.state;

    if (state is VehicleLoading) {
      await cubit.stream.firstWhere((s) => s is! VehicleLoading);
    }

    if (!mounted) return;

    state = cubit.state;

    if (state is VehicleError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
      return;
    }

    if (state is VehicleEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('لا توجد سيارات'),
        ),
      );
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

    if (!mounted) return;

    if (choice != null) {
      setState(() => _provinceValue = choice);
    }
  }

  Future<void> _onSubmit() async {
    FocusScope.of(context).unfocus();

    if (_selectedVehicle == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('الرجاء اختيار السيارة')));
      return;
    }

    if (_provinceValue.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('الرجاء اختيار المحافظة')));
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('الرجاء وصف المشكلة')));
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

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('يرجى تفعيل الموقع')));
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ بالموقع: $e')));
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('تم إرسال الطلب ✓'),
      ),
    );

    if (id != null) {
      // Replace the form so back from details returns to the list.
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
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.lightScaffold,
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
      ),
    );
  }
}
