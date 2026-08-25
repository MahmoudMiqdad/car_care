// ignore_for_file: deprecated_member_use
import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/technician_sos/domain/entities/technician_sos_entity.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/share_technician_location_cubit/share_technician_location_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_state.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/sos_requests_list/technician_cancel_response_dialog.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/technician_sos_details/technician_sos_details_request_card.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/technician_sos_details/technician_sos_details_section_card.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/technician_sos_details/technician_sos_details_status_banner.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/technician_sos_map_widget.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class SosTechnicianDetailsBody extends StatefulWidget {
  const SosTechnicianDetailsBody({
    super.key,
    required this.sos,
    required this.vehicleTitle,
    required this.plateNumber,
    required this.ownerName,
    required this.description,
    this.vehicleImageUrl,
    this.onCancelTapped,
    this.isMyRequest = false,
  });

  final TechnicianSosEntity sos;
  final String vehicleTitle;
  final String? vehicleImageUrl;
  final String plateNumber;
  final String ownerName;
  final String description;
  final VoidCallback? onCancelTapped;
  final bool isMyRequest;

  @override
  State<SosTechnicianDetailsBody> createState() =>
      _SosTechnicianDetailsBodyState();
}

class _SosTechnicianDetailsBodyState extends State<SosTechnicianDetailsBody> {
  bool _acceptedLocally = false;
  bool _mapOpened = false;

  String? get _status => widget.sos.status;

  bool get _isAccepted =>
      _acceptedLocally || _status == 'accepted' || _status == 'in_progress';

  bool get _isFinished =>
      _status == 'completed' || _status == 'cancelled' || _status == 'canceled';

  Future<void> _onNavigateTapped() async {
    if (_isFinished) return;

    if (_status == 'accepted') {
      final cubit = context.read<TechnicianSosCubit>();
      await cubit.changeStatus(widget.sos.id!, 'in_progress');
      if (!mounted) return;
      if (cubit.state is TechnicianError ||
          cubit.state is TechnicianActionError) {
        return;
      }
    }

    if (mounted) _openTechnicianMap(status: 'in_progress');
  }

  Future<void> _onCancelResponse(BuildContext context) async {
    final cubit = context.read<TechnicianSosCubit>();
    final reason = await showTechnicianCancelResponseDialog(context);
    if (reason == null) return;
    await cubit.cancelResponse(widget.sos.id!, reason);
  }

  void _openTechnicianMap({String? status}) {
    if (_mapOpened) return;
    _mapOpened = true;
    final l10n = context.l10n;
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
              create: (_) => getIt<ShareTechnicianLocationSosCubit>(),
              child: Scaffold(
                appBar: AppBar(
                  title: Text(l10n.sosNavigateToCustomer),
                  backgroundColor: AppColors.carWashTeal,
                  foregroundColor: AppColors.white,
                ),
                body: TechnicianMapWidget(
                  sosId: widget.sos.id!,
                  userLat: widget.sos.lat,
                  userLng: widget.sos.lng,
                  sosStatus: status ?? _status,
                ),
              ),
            ),
          ),
        )
        .then((_) {
          if (mounted) setState(() => _mapOpened = false);
        });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<TechnicianSosCubit, TechnicianSosState>(
      listener: (context, state) {
        if (state is TechnicianError) {
          final msg =
              state.message.isEmpty || state.message.startsWith('Instance of')
              ? l10n.sosGenericActionError
              : state.message;
          AppSnackBar.error(context, msg);
        }
        if (state is TechnicianActionError) {
          final msg =
              state.message.isEmpty || state.message.startsWith('Instance of')
              ? l10n.sosGenericActionError
              : state.message;
          AppSnackBar.error(context, msg);
        }
        if (state is TechnicianAccepted) {
          setState(() => _acceptedLocally = true);
          _openTechnicianMap(status: 'accepted');
        }
        if (state is TechnicianStatusChanged) {
          AppSnackBar.success(
            context,
            state.request.statusText?.trim().isNotEmpty == true
                ? l10n.sosStatusUpdatedWithLabel(state.request.statusText!)
                : l10n.sosStatusUpdated,
          );
        }
        if (state is TechnicianResponseCancelled) {
          AppSnackBar.success(context, state.message);
          context.safePopOrGo(Routes.technician_sos_requests);
        }
      },
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppConstants.pageHorizontal,
            16.h,
            AppConstants.pageHorizontal,
            24.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SosTechnicianDetailsStatusBanner(label: widget.sos.statusText!),
              SizedBox(height: 14.h),

              SosTechnicianDetailsRequestCard(
                vehicleTitle: widget.vehicleTitle,
                vehicleImageUrl: widget.vehicleImageUrl,
                plateNumber: widget.plateNumber,
                technicianName: widget.ownerName,
                description: widget.description,
              ),
              SizedBox(height: 14.h),

              if (!_isFinished) ...[
                _LocationPreviewCard(
                  sosId: widget.sos.id!,
                  lat: widget.sos.lat,
                  lng: widget.sos.lng,
                  isAccepted: _isAccepted,
                  onNavigateTap: _onNavigateTapped,
                ),
                SizedBox(height: 22.h),
              ],

              BlocBuilder<TechnicianSosCubit, TechnicianSosState>(
                builder: (context, state) {
                  final isBusy =
                      state is TechnicianActionLoading &&
                      state.sosId == widget.sos.id;

                  if (_status == 'open' && !_acceptedLocally) {
                    return AppButton(
                      onPressed: isBusy
                          ? null
                          : () => context
                                .read<TechnicianSosCubit>()
                                .acceptRequest(widget.sos.id!),
                      text: isBusy
                          ? l10n.sosAcceptingInProgress
                          : l10n.sosAcceptRequest,
                      backgroundColor: AppColors.carWashTeal,
                      textColor: AppColors.white,
                      borderRadius: 14.r,
                      height: 52.h,
                    );
                  }

                  if (_status != 'accepted' && _status != 'in_progress') {
                    return const SizedBox.shrink();
                  }

                  final isAccepted = _status == 'accepted';
                  return Column(
                    children: [
                      AppButton(
                        onPressed: isBusy
                            ? null
                            : () => context
                                  .read<TechnicianSosCubit>()
                                  .changeStatus(
                                    widget.sos.id!,
                                    isAccepted ? 'in_progress' : 'completed',
                                  ),
                        text: isBusy
                            ? l10n.sosProcessingInProgress
                            : (isAccepted
                                  ? l10n.sosStartProgress
                                  : l10n.sosFinishRequest),
                        backgroundColor: AppColors.carWashTeal,
                        textColor: AppColors.white,
                        borderRadius: 14.r,
                        height: 52.h,
                      ),
                      SizedBox(height: 12.h),
                      AppButton(
                        onPressed: isBusy
                            ? null
                            : () => _onCancelResponse(context),
                        text: l10n.sosCancelResponse,
                        backgroundColor: AppColors.red,
                        textColor: AppColors.white,
                        borderRadius: 14.r,
                        height: 52.h,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationPreviewCard extends StatelessWidget {
  const _LocationPreviewCard({
    required this.sosId,
    this.lat,
    this.lng,
    this.isAccepted = false,
    this.onNavigateTap,
  });

  final int sosId;
  final double? lat;
  final double? lng;
  final bool isAccepted;
  final VoidCallback? onNavigateTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasLocation = lat != null && lng != null;
    final location = hasLocation
        ? LatLng(lat!, lng!)
        : const LatLng(33.3152, 44.3661);

    return SosTechnicianDetailsSectionCard(
      title: l10n.sosCustomerLocation,
      bodyHeight: 200.h,
      clipBody: true,
      child: GestureDetector(
        onTap: isAccepted ? onNavigateTap : null,
        child: Stack(
          fit: StackFit.expand,
          children: [
            IgnorePointer(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: location,
                  initialZoom: 14,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.car_care.app',
                  ),
                  if (hasLocation)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: location,
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.location_on,
                            color: AppColors.red,
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            if (isAccepted)
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onNavigateTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.carWashTeal,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.shadow.withOpacity(0.2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.navigation,
                          color: AppColors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.sosStartNavigateToCustomer,
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            if (!isAccepted)
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.sosAcceptToNavigateHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
