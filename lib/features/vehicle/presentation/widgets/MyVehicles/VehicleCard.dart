// ignore_for_file: file_names
import 'package:car_care/core/constants/appbox_container.dart';

import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';

import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_cubit.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({super.key, required this.item});

  final VehicleEntity item;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return AppBoxContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VehicleCircleImage(imageUrl: item.image),
              SizedBox(width: 16.w),
              Expanded(
                child: VehicleInfoColumn(item: item),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AppButton(
            text: strings.details,
            backgroundColor: AppColors.accent,
            borderRadius: 16.r,
            height: 48.h,
            onPressed: () async {
              final deleted = await context.push<bool>(Routes.vehicle_details, extra: item.id);
              if (deleted == true && context.mounted) {
                context.read<VehicleCubit>().getAllVehicles();
              }
            },
          ),
        ],
      ),
    );
  }
}

class VehicleInfoColumn extends StatelessWidget {
  final VehicleEntity item;
  const VehicleInfoColumn({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.sectionTitle(
          context,
          '${item.brand} ${item.model}',
          color: AppColors.black,
        ),
        SizedBox(height: 8.h),
        AppInfoRow(
          label: strings.year,
          value: item.year.toString(),
        ),
        SizedBox(height: 4.h),
        AppInfoRow(
          label: strings.plate,
          value: item.plateNumber,
        ),
        SizedBox(height: 4.h),
        AppInfoRow(
          label: strings.counterAppBarTitle,
          value: strings.odometerReadingWithParamLabel(item.currentKm.toString()),
        ),
      ],
    );
  }
}

class VehicleCircleImage extends StatelessWidget {
  final String? imageUrl;
  const VehicleCircleImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();

    Widget buildPlaceholder() => Icon(Icons.directions_car, size: 40.sp, color: AppColors.accent);

    return Container(
      width: 90.w,
      height: 90.w,
   
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.border(context),
      ),
      child: ClipOval(
        child: (url != null && url.isNotEmpty)
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => buildPlaceholder(),
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            : buildPlaceholder(),
      ),
    );
  }
}
