import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
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
  const TechnicianSosRequestsListPage({super.key, required this.type});

  final SosRequestType type;

  @override
  State<TechnicianSosRequestsListPage> createState() =>
      _SosRequestsListPageState();
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

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: CustomAppBar(
        title: widget.type == SosRequestType.available
            ? l10n.sosRequestsListTitle
            : l10n.acceptedSosRequests,
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
      body: ImageBackground(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: BlocConsumer<TechnicianSosCubit, TechnicianSosState>(
            listenWhen: (_, current) =>
                current is TechnicianError ||
                current is TechnicianActionError ||
                current is TechnicianResponseCancelled ||
                current is TechnicianStatusChanged,
            listener: (context, state) {
              if (state is TechnicianError) {
                final msg =
                    state.message.isEmpty ||
                        state.message.startsWith('Instance of')
                    ? l10n.unexpectedErrorTryAgain
                    : state.message;
                AppSnackBar.error(context, msg);
              }
              if (state is TechnicianActionError) {
                final msg =
                    state.message.isEmpty ||
                        state.message.startsWith('Instance of')
                    ? l10n.unexpectedErrorTryAgain
                    : state.message;
                AppSnackBar.error(context, msg);
              }
              if (state is TechnicianResponseCancelled) {
                AppSnackBar.success(context, state.message);
                _load();
              }
              if (state is TechnicianStatusChanged) {
                AppSnackBar.success(
                  context,
                  state.request.statusText?.trim().isNotEmpty == true
                      ? l10n.statusUpdatedWithDynamicLabel(
                          state.request.statusText!,
                        )
                      : l10n.statusUpdatedSuccessMessage,
                );
                _load();
              }
            },
            buildWhen: (_, current) =>
                current is TechnicianLoading ||
                current is TechnicianError ||
                current is TechnicianAvailableLoaded,
            builder: (context, state) {
              if (state is TechnicianLoading) {
                return const Center(child: AppLoadingWidget());
              }
          
              if (state is TechnicianError) {
                return ErrorStateWidget(
                  message:
                      state.message.isEmpty ||
                          state.message.startsWith('Instance of')
                      ? l10n.jobLoadErrorLabel
                      : state.message,
                  onRetry: _load,
                );
              }
          
              if (state is TechnicianAvailableLoaded) {
                final list = state.list;
          
                if (list.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 60.h),
                      const EmptyStateWidget(),
                   
                    ],
                  );
                }
          
                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(AppConstants.pageHorizontal),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    return TechnicianSosRequestCard(
                      item: list[index],
                      showAcceptButton: widget.type == SosRequestType.available,
                      onRefreshList: _load,
                    );
                  },
                );
              }
          
              return ListView(
                children: [
                  SizedBox(height: 200.h),
                  Center(child: Text(l10n.noAvailableRequests)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
