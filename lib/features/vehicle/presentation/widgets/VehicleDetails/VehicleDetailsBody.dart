// ignore_for_file: file_names
import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/core/widgets/vehicle_header.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/presentation/cubit/delete_vehicle/vehicle_delete_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/delete_vehicle/vehicle_delete_state.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_details_cubit/vehicle_details_cubit.dart';
import 'package:car_care/features/vehicle/presentation/widgets/VehicleDetails/DeleteConfirmationDialog.dart';
import 'package:car_care/features/vehicle/presentation/widgets/VehicleDetails/QuickActionButton.dart';
import 'package:car_care/features/vehicle/presentation/widgets/VehicleDetails/ServiceRecordTile.dart';
import 'package:car_care/features/vehicle/presentation/widgets/VehicleDetails/VehicleInfoCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class VehicleDetailsBody extends StatelessWidget {
  const VehicleDetailsBody({super.key, required this.vehicle});

  final VehicleEntity vehicle;

  String get vehicleName {
    final b = vehicle.brand.trim();
    final m = vehicle.model.trim();
    if (b.isEmpty && m.isEmpty) return 'سيارة';
    return '$b $m'.trim();
  }

  String get ownerName {
    final o = vehicle.ownerName?.trim();
    return (o == null || o.isEmpty) ? 'غير معروف' : o;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VehicleHeader(
            imagePath: vehicle.image ?? '',
            isNetworkImage: true,
            title: vehicleName,
            bottomChild: AppText.sectionTitle(
              'المالك:  $ownerName',
              color: Colors.black87,
                 textAlign: TextAlign.center,
              alignment: Alignment.center,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: VehicleInfoCardWidget(
                  title: 'عداد الكيلومترات',
                  value: '${vehicle.currentKm} كم',
                  icon: Icon(
                    Icons.speed_outlined,
                    color: AppColors.primary,
                    size: 28.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: VehicleInfoCardWidget(
                  title: 'رقم لوحة السيارة',
                  value: vehicle.plateNumber,
                  icon: Image.asset(
                    AppAssets.plateNumberIcon,
                    width: 30.w,
                    height: 30.h,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          AppText.sectionTitle('سجلات الخدمات'),
          SizedBox(height: 5.h),
          ServiceRecordTile(
            title: 'سجل الصيانة',
            icon: Icons.build_outlined,
            onTap: () {
              context.push(
                Routes.maintenanceHistory,
                extra: vehicle.id,
              );
            },
          ),
          SizedBox(height: 5.h),
          ServiceRecordTile(
            title: 'سجل الوقود',
            icon: Icons.local_gas_station_outlined,
            onTap: () {},
          ),
          SizedBox(height: 5.h),
          ServiceRecordTile(
            title: 'سجل التنبيهات',
            icon: Icons.notifications_none_outlined,
            onTap: () {},
          ),
          SizedBox(height: 5.h),
          AppText.sectionTitle('إجراءات سريعة'),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              QuickActionButton(
                label: 'حذف',
                iconPath: AppAssets.deleteIcon,
                color: const Color(0xFFA12323),
                onTap: () {
                  showCustomDeleteDialog(
                    context: context,
                    vehicleId: vehicle.id,
                    vehicleName: vehicleName,
                  );
                },
              ),
              QuickActionButton(
                label: 'تعديل',
                iconPath: AppAssets.editIcon,
                color: AppColors.primary,
                onTap: () async {
                  final updated = await context.push<bool>(
                    Routes.updateVehicle,
                    extra: vehicle.id,
                  );

                  if (updated == true && context.mounted) {
                    context.read<VehicleDetailsCubit>().fetchVehicleDetails(
                          vehicle.id,
                        );
                  }
                },
              ),
              QuickActionButton(
                label: 'صيانة',
                iconPath: AppAssets.maintenanceIcon,
                color: AppColors.primary,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showCustomDeleteDialog({
  required BuildContext context,
  required String vehicleName,
  required int vehicleId,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'delete_vehicle',
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (dialogContext, _, __) {
      return BlocProvider(
        create: (_) => getIt<VehicleDeleteCubit>(),
        child: BlocConsumer<VehicleDeleteCubit, VehicleDeleteState>(
          listener: (ctx, state) {
            if (state is VehicleDeleteSuccess) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف المركبة بنجاح')),
              );
              if (context.mounted) {
                context.pop(true);
              }
            }
            if (state is VehicleDeleteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (ctx, state) {
            final isLoading = state is VehicleDeleteLoading;
            return DeleteConfirmationDialog(
              vehicleName: vehicleName,
              isLoading: isLoading,
              onDelete: isLoading
                  ? null
                  : () =>
                      ctx.read<VehicleDeleteCubit>().deleteVehicle(vehicleId),
            );
          },
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.scale(
        scale: Curves.easeInOutBack.transform(anim1.value),
        child: Opacity(opacity: anim1.value, child: child),
      );
    },
  );
}