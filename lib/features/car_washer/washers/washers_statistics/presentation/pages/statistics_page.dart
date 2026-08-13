import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/presentation/cubit/statistics_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/presentation/cubit/statistics_state.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/presentation/widgets/washer_statistics/washer_statistics_body.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CarWasherStatisticsPage extends StatelessWidget {
  const CarWasherStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CarWasherStatisticsCubit>()..load()),
        // Statistics has no carWasherId of its own — the ratings section
        // embedded in the body gets it from the washer's own profile
        // (my_profile), reusing the existing ProfileWasherCubit instead of
        // adding a new endpoint/repository just for this id.
        BlocProvider(create: (_) => getIt<ProfileWasherCubit>()..load()),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.lightScaffold,
          appBar: CustomAppBar(
            title: strings.statistics,
            showBackButton: true,
            onBackTapped: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(Routes.profile_washer);
              }
            },
          ),
          body: ImageBackground(
            child: BlocBuilder<CarWasherStatisticsCubit, StatisticsState>(
              builder: (context, state) {
                if (state is StatisticsLoading || state is StatisticsInitial) {
                  return const Center(child: AppLoadingWidget());
                }

                if (state is StatisticsLoaded) {
                  return WasherStatisticsBody(statistics: state.statistics);
                }

                if (state is StatisticsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(state.message, textAlign: TextAlign.center),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () =>
                              context.read<CarWasherStatisticsCubit>().load(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('إعادة محاولة'),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
