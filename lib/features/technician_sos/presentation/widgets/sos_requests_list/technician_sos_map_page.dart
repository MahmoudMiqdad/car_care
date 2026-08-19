import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/share_technician_location_cubit/share_technician_location_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_state.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/technician_sos_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TechnicianSosMapPage extends StatelessWidget {
  final int sosId;
  final double? clientLat;
  final double? clientLng;

  const TechnicianSosMapPage({
    super.key,
    required this.sosId,
    this.clientLat,
    this.clientLng,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ShareTechnicianLocationSosCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<TechnicianSosCubit>()..getRequest(sosId),
        ),
      ],
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.lightScaffold,
          appBar: AppBar(
            backgroundColor: AppColors.carWashTeal,
            foregroundColor: Colors.white,
            title: Text(
              'تتبع الطلب #$sosId',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('تأكيد الخروج'),
                    content: const Text(
                        'سيتوقف إرسال موقعك للعميل. هل تريد الخروج؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.safePopOrGo(Routes.technician_sos_requests);
                        },
                        child: const Text(
                          'خروج',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          body: BlocListener<TechnicianSosCubit, TechnicianSosState>(
            listener: (context, state) {
              if (state is TechnicianRequestLoaded &&
                  state.request.status == 'completed') {
                AppSnackBar.success(context, 'تم إنهاء الطلب بنجاح ✓');
                Future.delayed(const Duration(seconds: 1), () {
                  if (context.mounted) {
                    context.safePopOrGo(Routes.technician_sos_requests);
                  }
                });
              }
            },
            child: TechnicianMapWidget(
              sosId: sosId,
              userLat: clientLat,
              userLng: clientLng,
            ),
          ),
        ),
      ),
    );
  }
}