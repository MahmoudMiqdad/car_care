import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/floating_add_button.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/sos/presentation/cubit/sos_cubit/sos_cubit.dart';
import 'package:car_care/features/sos/presentation/cubit/sos_cubit/sos_state.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_request_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SosRequestsListPage extends StatelessWidget {
  const SosRequestsListPage({super.key});

  Future<void> _openCreateSos(BuildContext context) async {
    await context.push(Routes.create_sos);
    if (context.mounted) context.read<SosCubit>().getAll(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 16.h, left: 16.w),
          child: FloatingAddButton(onTap: () => _openCreateSos(context)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        appBar: CustomAppBar(
          title: l10n.sosRequestsListTitle,
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
          child: BlocBuilder<SosCubit, SosState>(
            builder: (context, state) {
              if (state is SosLoading) {
                return const Center(child: AppLoadingWidget());
              }

              if (state is SosError) {
                return ErrorStateWidget(
                  message: state.message,
                  onRetry: () => context.read<SosCubit>().getAll(),
                );
              }

              if (state is SosListLoaded) {
                final sosList = state.listSOs;

                return RefreshIndicator(
                  // silent: keep the current list visible while refreshing;
                  // only the pull indicator spins.
                  onRefresh: () =>
                      context.read<SosCubit>().getAll(silent: true),
                  child: sosList.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 60.h),
                            const EmptyStateWidget(),
                            SizedBox(height: 16.h),
                            Center(
                              child: TextButton.icon(
                                onPressed: () => _openCreateSos(context),
                                icon: const Icon(Icons.add),
                                label: const Text('إنشاء طلب طوارئ'),
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            AppConstants.pageHorizontal,
                            16.h,
                            AppConstants.pageHorizontal,
                            16.h,
                          ),
                          itemCount: sosList.length,
                          separatorBuilder: (_, _) => SizedBox(height: 16.h),
                          itemBuilder: (context, index) {
                            return SosRequestCard(item: sosList[index]);
                          },
                        ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
