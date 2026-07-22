import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_state.dart';
import 'package:car_care/features/technician_sos/presentation/technician_sos_request_type.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/sos_requests_list/technician_sos_request_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TechnicianSosRequestsListPage extends StatefulWidget {
  const TechnicianSosRequestsListPage({
    super.key,
    required this.type,
  });

  final SosRequestType type;

  @override
  State<TechnicianSosRequestsListPage> createState() => _SosRequestsListPageState();
}

class _SosRequestsListPageState extends State<TechnicianSosRequestsListPage> {

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final cubit = context.read<TechnicianSosCubit>();

    if (widget.type == SosRequestType.available) {
      cubit.getAvailableRequests();
    } else {
      cubit.myRequests();
    }
  }

  Future<void> _onRefresh() async {
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

 return Directionality(
  textDirection: TextDirection.rtl,
  child: Scaffold(
    backgroundColor: AppColors.lightScaffold,
    appBar: CustomAppBar(
      title: widget.type == SosRequestType.available
          ? l10n.sosRequestsListTitle
          : "طلباتي",
      showBackButton: true,
      backgroundColor: AppColors.carWashTeal,
      onBackTapped: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(Routes.home);
        }
      },
    ),
    body: RefreshIndicator(
      onRefresh: _onRefresh,
      child: ImageBackground(
        child: BlocConsumer<TechnicianSosCubit, TechnicianSosState>(
          listenWhen: (_, current) => current is TechnicianError,
          listener: (context, state) {
            if (state is TechnicianError) {
              final msg = state.message.isEmpty ||
                      state.message.startsWith('Instance of')
                  ? 'حدث خطأ أثناء تحميل الطلبات'
                  : state.message;
              AppSnackBar.error(context, msg);
            }
          },
          builder: (context, state) {
            if (state is TechnicianLoading) {
              return const Center(child: AppLoadingWidget());
            }

            if (state is TechnicianError) {
              return ListView(
                children: [
                  const SizedBox(height: 160),
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text('حدث خطأ أثناء تحميل الطلبات'),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _load,
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ),
                ],
              );
            }

            if (state is TechnicianAvailableLoaded) {
              final list = state.list;

              if (list.isEmpty) {
                return ListView( 
                  children: [
                    SizedBox(height: 200),
                    Center(child: Text(l10n.noAvailableRequests)),
                  ],
                );
              }

              return ListView.separated(
                padding: EdgeInsets.all(AppConstants.pageHorizontal),
                itemCount: list.length,
                separatorBuilder: (_, _) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  return TechnicianSosRequestCard(
                    item: list[index],
                    showAcceptButton:
                        widget.type == SosRequestType.available,
                  );
                },
              );
            }

            return ListView( 
              children: [
                SizedBox(height: 200),
                Center(child: Text(l10n.noAvailableRequests)),
              ],
            );
          },
        ),
      ),
    ),
  ),
);
  }
}