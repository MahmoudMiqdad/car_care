import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_details_entity.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/cancel_request_cubit/cancel_request_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/cancel_request_cubit/cancel_request_state.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/show_request_cubit/show_request_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/show_request_cubit/show_request_state.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/request_details/request_action_buttons.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/request_details/request_images_section.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/request_details/request_info_card.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/request_details/technician_card.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/request_details/vehicle_card.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_status_banner.dart';
import 'package:car_care/l10n.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class MaintenanceRequestDetailsPage extends StatefulWidget {
  const MaintenanceRequestDetailsPage({super.key, required this.requestId});

  final int requestId;

  @override
  State<MaintenanceRequestDetailsPage> createState() =>
      _MaintenanceRequestDetailsPageState();
}

class _MaintenanceRequestDetailsPageState
    extends State<MaintenanceRequestDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShowRequestCubit>().fetchRequest(widget.requestId.toString());
  }

  void _showFullMapDialog(
    BuildContext context,
    RequestCurrentLocationEntity location,
  ) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.87), 
      builder: (_) => Dialog.fullscreen(
        backgroundColor: AppColors.black,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(location.lat, location.lng),
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.car_care.app',
                  maxNativeZoom: 19,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(location.lat, location.lng),
                      width: 40.w,
                      height: 40.h,
                      child: Icon(
                        Icons.location_pin,
                        color: AppColors.carWashTeal,
                        size: 40.r,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 40.h,
              right: 16.w,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.26), 
                        blurRadius: 6.r,
                      ),
                    ],
                  ),
                  child: Icon(Icons.close, color: AppColors.black, size: 22.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; 

    return BlocListener<CancelRequestCubit, CancelRequestState>(
      listener: (context, state) {
        if (state is CancelRequestSuccess) {
          final message = state.request.message?.trim();
          AppSnackBar.success(
            context,
            message == null || message.isEmpty
                ? l10n.orderCancelledSuccess 
                : message,
          );
          context.safePopOrGo(Routes.all_requests);
        }
        if (state is CancelRequestError) {
          final msg =
              state.message.isEmpty || state.message.startsWith('Instance of')
              ? l10n.unexpectedErrorTryAgain
              : state.message;
          AppSnackBar.error(context, msg);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        appBar: CustomAppBar(
          title: l10n.maintenanceRequestDetailsTitle, 
          showBackButton: true,
          backgroundColor: AppColors.carWashTeal,
          onBackTapped: () => context.safePopOrGo(Routes.all_requests),
        ),
        body: ImageBackground(
          child: SafeArea(
            child: BlocBuilder<ShowRequestCubit, ShowRequestState>(
              builder: (context, state) {
                if (state is ShowRequestLoading ||
                    state is ShowRequestInitial) {
                  return const Center(child: AppLoadingWidget());
                }

                if (state is ShowRequestError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                          ),
                          onPressed: () => context
                              .read<ShowRequestCubit>()
                              .fetchRequest(widget.requestId.toString()),
                          child: Text(l10n.retry), 
                        ),
                      ],
                    ),
                  );
                }

                if (state is ShowRequestLoaded) {
                  return _buildContent(context, state.request);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    MaintenanceRequestDetailsEntity request,
  ) {
    final assigned = request.data.assignedTechnician;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppConstants.pageHorizontal,
        16.h,
        AppConstants.pageHorizontal,
        24.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SosDetailsStatusBanner(label: request.data.statusText),
          SizedBox(height: 14.h),

          RequestInfoCard(data: request.data),
          SizedBox(height: 14.h),

          if (request.data.vehicle != null) ...[
            VehicleCard(vehicle: request.data.vehicle!),
            SizedBox(height: 14.h),
          ],

          if (request.data.images.isNotEmpty &&
              request.data.status != 'completed') ...[
            RequestImagesSection(images: request.data.images),
            SizedBox(height: 14.h),
          ],

          if (assigned != null && request.data.status != 'completed') ...[
            TechnicianCard(
              technician: assigned,
              onMapTap: () =>
                  _showFullMapDialog(context, assigned.currentLocation!),
            ),
            SizedBox(height: 14.h),
          ],

          RequestActionButtons(
            data: request.data,
            requestId: widget.requestId.toString(),
          ),
        ],
      ),
    );
  }
}
