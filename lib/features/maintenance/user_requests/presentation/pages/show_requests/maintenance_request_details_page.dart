// // maintenance_request_details_page.dart

// import 'package:car_care/core/constants/app_assets.dart';
// import 'package:car_care/core/constants/app_constants.dart';
// import 'package:car_care/core/routing/routes.dart';
// import 'package:car_care/core/theme/app_colors.dart';
// import 'package:car_care/core/theme/buttons/app_button_widget.dart';
// import 'package:car_care/core/utils/app_snackbar.dart';
// import 'package:car_care/core/widgets/custom_appbar.dart';
// import 'package:car_care/core/widgets/image_background.dart';
// import 'package:car_care/core/widgets/loding.dart';
// import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_details_entity.dart';
// import 'package:car_care/features/maintenance/user_requests/presentation/cubit/cancel_request_cubit/cancel_request_cubit.dart';
// import 'package:car_care/features/maintenance/user_requests/presentation/cubit/cancel_request_cubit/cancel_request_state.dart';
// import 'package:car_care/features/maintenance/user_requests/presentation/cubit/show_request_cubit/show_request_cubit.dart';
// import 'package:car_care/features/maintenance/user_requests/presentation/cubit/show_request_cubit/show_request_state.dart';
// import 'package:car_care/features/maintenance/user_requests/presentation/widgets/all_requests/delete_request_dialog.dart';
// import 'package:car_care/features/maintenance/user_requests/presentation/widgets/cancel_request_dialog.dart';
// import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_info_row.dart';
// import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_section_card.dart';
// import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_status_banner.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:latlong2/latlong.dart';

// class MaintenanceRequestDetailsPage extends StatefulWidget {
//   const MaintenanceRequestDetailsPage({super.key, required this.requestId});

//   final int requestId;

//   @override
//   State<MaintenanceRequestDetailsPage> createState() =>
//       _MaintenanceRequestDetailsPageState();
// }

// class _MaintenanceRequestDetailsPageState
//     extends State<MaintenanceRequestDetailsPage> {
//   static String _formatDate(DateTime d) =>
//       '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

//   @override
//   void initState() {
//     super.initState();
//     context.read<ShowRequestCubit>().fetchRequest(widget.requestId.toString());
//   }

//   void _showFullMapDialog(
//       BuildContext context, RequestCurrentLocationEntity location) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black87,
//       builder: (_) => Dialog.fullscreen(
//         backgroundColor: Colors.black,
//         child: Stack(
//           children: [
//             FlutterMap(
//               options: MapOptions(
//                 initialCenter: LatLng(location.lat, location.lng),
//                 initialZoom: 15,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate:
//                       'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   userAgentPackageName: 'com.car_care.app',
//                   maxNativeZoom: 19,
//                 ),
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       point: LatLng(location.lat, location.lng),
//                       width: 40.w,
//                       height: 40.h,
//                       child: Icon(
//                         Icons.location_pin,
//                         color: AppColors.carWashTeal,
//                         size: 40.r,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Positioned(
//               top: 40.h,
//               right: 16.w,
//               child: GestureDetector(
//                 onTap: () => Navigator.of(context).pop(),
//                 child: Container(
//                   padding: EdgeInsets.all(8.r),
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 6.r,
//                       ),
//                     ],
//                   ),
//                   child: Icon(
//                     Icons.close,
//                     color: AppColors.black,
//                     size: 22.r,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<CancelRequestCubit, CancelRequestState>(
//       listener: (context, state) {
//         if (state is CancelRequestSuccess) {
//           AppSnackBar.success(context, 'تم إلغاء الطلب بنجاح');
//           context.pop();
//         }
//         if (state is CancelRequestError) {
//           AppSnackBar.error(context, state.message);
//         }
//       },
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//           backgroundColor: AppColors.lightScaffold,
//           appBar: CustomAppBar(
//             title: 'تفاصيل الطلب',
//             showBackButton: true,
//             backgroundColor: AppColors.carWashTeal,
//             onBackTapped: () => context.pop(),
//           ),
//           body: ImageBackground(
//             child: SafeArea(
//               bottom: false,
//               child: BlocBuilder<ShowRequestCubit, ShowRequestState>(
//                 builder: (context, state) {
//                   if (state is ShowRequestLoading ||
//                       state is ShowRequestInitial) {
//                     return const Center(child: AppLoadingWidget());
//                   }

//                   if (state is ShowRequestError) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             state.message,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 16.sp),
//                           ),
//                           SizedBox(height: 16.h),
//                           ElevatedButton(
//                             onPressed: () => context
//                                 .read<ShowRequestCubit>()
//                                 .fetchRequest(widget.requestId.toString()),
//                             child: const Text('إعادة المحاولة'),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   if (state is ShowRequestLoaded) {
//                     return _buildContent(context, state.request);
//                   }

//                   return const SizedBox.shrink();
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildContent(
//       BuildContext context, MaintenanceRequestDetailsEntity request) {
//     final vehicle = request.data.vehicle;
//     final assigned = request.data.assignedTechnician;
//     final techLocation = assigned?.currentLocation;

//     return SingleChildScrollView(
//       padding: EdgeInsets.fromLTRB(
//         AppConstants.pageHorizontal,
//         16.h,
//         AppConstants.pageHorizontal,
//         24.h,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           SosDetailsStatusBanner(label: request.data.statusText),
//           SizedBox(height: 14.h),

//           // بطاقة بيانات الطلب
//           SosDetailsSectionCard(
//             title: 'بيانات الطلب',
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SosDetailsInfoRow(
//                   iconAsset: AppAssets.technicianJobNotesIcon,
//                   label: 'الوصف',
//                   value: request.data.description,
//                 ),
//                 SosDetailsInfoRow(
//                   iconAsset: AppAssets.calendarIcon,
//                   label: 'الموعد المفضل',
//                   value: request.data.preferredDate != null
//                       ? _formatDate(request.data.preferredDate!)
//                       : '-',
//                 ),
//                 SosDetailsInfoRow(
//                   iconAsset: AppAssets.technicianJobNotesIcon,
//                   label: 'الأولوية',
//                   value: request.data.priorityText,
//                 ),
//                 SosDetailsInfoRow(
//                   iconAsset: AppAssets.technicianJobNotesIcon,
//                   label: 'تاريخ الإنشاء',
//                   value: request.data.createdAgo ?? '-',
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 14.h),

//           // بطاقة المركبة
//           if (vehicle != null) ...[
//             SosDetailsSectionCard(
//               title: 'المركبة',
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 textDirection: TextDirection.rtl,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Text(
//                           '${vehicle.brand ?? ''} ${vehicle.model ?? ''} ${vehicle.year ?? ''}'
//                               .trim(),
//                           style: TextStyle(
//                             fontSize: 22.sp,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.black,
//                           ),
//                         ),
//                         SizedBox(height: 8.h),
//                         SosDetailsInfoRow(
//                           iconAsset: AppAssets.plateNumberIcon,
//                           label: 'رقم اللوحة',
//                           value: vehicle.plateNumber ?? '-',
//                         ),
//                         SosDetailsInfoRow(
//                           iconAsset: AppAssets.technicianJobNotesIcon,
//                           label: 'الكيلومترات',
//                           value: vehicle.currentKm != null
//                               ? '${vehicle.currentKm} كم'
//                               : '-',
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 12.w),
//                   CircleAvatar(
//                     radius: 40.r,
//                     backgroundColor: AppColors.lightSurface,
//                     backgroundImage:
//                         const AssetImage(AppAssets.technicianJobVehicleIcon),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 14.h),
//           ],

//           // صور الطلب
//           if (request.data.images.isNotEmpty) ...[
//             SosDetailsSectionCard(
//               title: 'صور الطلب',
//               child: SizedBox(
//                 height: 100.h,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: request.data.images.length,
//                   separatorBuilder: (_, __) => SizedBox(width: 8.w),
//                   itemBuilder: (_, i) => ClipRRect(
//                     borderRadius: BorderRadius.circular(10.r),
//                     child: Image.network(
//                       request.data.images[i].url,
//                       width: 100.w,
//                       height: 100.h,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => Container(
//                         width: 100.w,
//                         color: AppColors.lightSurface,
//                         child: Icon(Icons.image_not_supported_outlined,
//                             color: AppColors.carWashTeal),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 14.h),
//           ],

//           // الفني المعين
//           if (assigned != null) ...[
//             SosDetailsSectionCard(
//               title: 'الفني المعين',
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     assigned.name,
//                     style: TextStyle(
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.black,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   SosDetailsInfoRow(
//                     iconAsset: AppAssets.iconPhoneCall,
//                     label: 'الهاتف',
//                     value: assigned.phone,
//                   ),
//                   SosDetailsInfoRow(
//                     iconAsset: AppAssets.technicianJobNotesIcon,
//                     label: 'التخصص',
//                     value: assigned.specialization,
//                   ),
//                   SosDetailsInfoRow(
//                     iconAsset: AppAssets.calendarIcon,
//                     label: 'سنوات الخبرة',
//                     value: '${assigned.experienceYears} سنوات',
//                   ),

//                   // خريطة موقع الفني
//                   if (techLocation != null) ...[
//                     SizedBox(height: 12.h),
//                     Text(
//                       'موقع الفني',
//                       style: TextStyle(
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.black,
//                       ),
//                     ),
//                     SizedBox(height: 8.h),
//                     GestureDetector(
//                       onTap: () => _showFullMapDialog(context, techLocation),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12.r),
//                         child: SizedBox(
//                           height: 160.h,
//                           width: double.infinity,
//                           child: Stack(
//                             children: [
//                               FlutterMap(
//                                 options: MapOptions(
//                                   initialCenter: LatLng(
//                                     techLocation.lat,
//                                     techLocation.lng,
//                                   ),
//                                   initialZoom: 15,
//                                   interactionOptions:
//                                       const InteractionOptions(
//                                     flags: InteractiveFlag.none,
//                                   ),
//                                 ),
//                                 children: [
//                                   TileLayer(
//                                     urlTemplate:
//                                         'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                                     userAgentPackageName: 'com.car_care.app',
//                                     maxNativeZoom: 19,
//                                   ),
//                                   MarkerLayer(
//                                     markers: [
//                                       Marker(
//                                         point: LatLng(
//                                           techLocation.lat,
//                                           techLocation.lng,
//                                         ),
//                                         width: 36.w,
//                                         height: 36.h,
//                                         child: Icon(
//                                           Icons.location_pin,
//                                           color: AppColors.carWashTeal,
//                                           size: 36.r,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Positioned(
//                                 bottom: 8.h,
//                                 left: 8.w,
//                                 child: Container(
//                                   padding: EdgeInsets.all(6.r),
//                                   decoration: BoxDecoration(
//                                     color:
//                                         AppColors.white.withValues(alpha: 0.85),
//                                     borderRadius: BorderRadius.circular(8.r),
//                                   ),
//                                   child: Icon(
//                                     Icons.fullscreen,
//                                     color: AppColors.carWashTeal,
//                                     size: 20.r,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             SizedBox(height: 14.h),
//           ],

//           // زر عروض الأسعار
//           AppButton(
//             onPressed: () {
//               context.push(
//                 Routes.quotations,
//                 extra: request.data.id.toString(),
//               );
//             },
//             text: 'عروض الأسعار (${request.data.quotations.length})',
//             backgroundColor: AppColors.primary,
//             textColor: AppColors.white,
//             borderRadius: 14.r,
//             height: 52.h,
//           ),

//           // زر إلغاء الطلب
//           if (request.data.canCancel) ...[
//             SizedBox(height: 12.h),
//             BlocBuilder<CancelRequestCubit, CancelRequestState>(
//               builder: (context, cancelState) {
//                 final isLoading = cancelState is CancelRequestLoading;
//                 return AppButton(
//                   onPressed: isLoading
//                       ? null
//                       : () async {
//                           final reason =
//                               await showCancelRequestDialog(context);
//                           if (reason == null) return;
//                           if (!context.mounted) return;
//                         context.read<CancelRequestCubit>().cancelRequest(
//   id: widget.requestId.toString(),
//   reason: reason,
// );
//                         },
//                   text: isLoading ? 'جاري الإلغاء...' : 'إلغاء الطلب',
//                   backgroundColor: AppColors.reservationConfirmOrange,
//                   textColor: AppColors.white,
//                   borderRadius: 14.r,
//                   height: 52.h,
//                 );
//               },
//             ),
//           ],
     
// SizedBox(height: 12.h),
// BlocListener<CancelRequestCubit, CancelRequestState>(
//   listener: (context, state) {
//     if (state is DeleteRequestSuccess) {
//       AppSnackBar.success(context, 'تم حذف الطلب بنجاح');
//       context.pop();
//     }
//     if (state is DeleteRequestError) {
//       AppSnackBar.success(context, state.message);
//       context.pop();
//     }
//   },
//   child: BlocBuilder<CancelRequestCubit, CancelRequestState>(
//     builder: (context, cancelState) {
//       final isLoading = cancelState is CancelRequestLoading;
//       return AppButton(
//         onPressed: isLoading
//             ? null
//             : () async {
//                 final confirmed = await showDeleteRequestDialog(context);
//                 if (confirmed != true) return;
//                 if (!context.mounted) return;
//                 context.read<CancelRequestCubit>().deleteRequest(
//                       id: widget.requestId.toString(),
//                     );
//               },
//         text: isLoading ? 'جاري الحذف...' : 'حذف الطلب',
//         backgroundColor: Colors.red.shade600,
//         textColor: AppColors.white,
//         borderRadius: 14.r,
//         height: 52.h,
//       );
//     },
//   ),
// ),
//         ],
//       ),
//     );
//   }
  
//}
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
      BuildContext context, RequestCurrentLocationEntity location) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(location.lat, location.lng),
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6.r)],
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
    return BlocListener<CancelRequestCubit, CancelRequestState>(
      listener: (context, state) {
        if (state is CancelRequestSuccess) {
          AppSnackBar.success(context, 'تم إلغاء الطلب بنجاح');
          context.safePopOrGo(Routes.all_requests);
        }
        if (state is CancelRequestError) {
          AppSnackBar.error(context, state.message);
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.lightScaffold,
          appBar: CustomAppBar(
            title: 'تفاصيل الطلب',
            showBackButton: true,
            backgroundColor: AppColors.carWashTeal,
            onBackTapped: () => context.safePopOrGo(Routes.all_requests),
          ),
          body: ImageBackground(
            child: SafeArea(
              bottom: false,
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
                            onPressed: () => context
                                .read<ShowRequestCubit>()
                                .fetchRequest(widget.requestId.toString()),
                            child: const Text('إعادة المحاولة'),
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
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, MaintenanceRequestDetailsEntity request) {
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

          if (request.data.images.isNotEmpty) ...[
            RequestImagesSection(images: request.data.images),
            SizedBox(height: 14.h),
          ],

          if (assigned != null) ...[
            TechnicianCard(
              technician: assigned,
              onMapTap: () => _showFullMapDialog(
                context,
                assigned.currentLocation!,
              ),
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