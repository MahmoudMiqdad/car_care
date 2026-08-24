import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/utils/media_url.dart';
import 'package:car_care/features/vehicle/domain/entities/fuel_log_entity.dart';
import 'package:car_care/features/vehicle/presentation/cubit/fuel_logs/fuel_logs_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/fuel_logs/fuel_logs_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleFuelLogsPage extends StatelessWidget {
  const VehicleFuelLogsPage({super.key, required this.vehicleId});

  final int vehicleId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<FuelLogsCubit>()..fetch(vehicleId),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        appBar: CustomAppBar(title: l10n.fuelLogTitle, showBackButton: true),
        body: ImageBackground(child: _FuelLogsBody(vehicleId: vehicleId)),
      ),
    );
  }
}

class _FuelLogsBody extends StatefulWidget {
  const _FuelLogsBody({required this.vehicleId});

  final int vehicleId;

  @override
  State<_FuelLogsBody> createState() => _FuelLogsBodyState();
}

class _FuelLogsBodyState extends State<_FuelLogsBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final nearBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;
    if (nearBottom) {
      context.read<FuelLogsCubit>().loadMore(widget.vehicleId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FuelLogsCubit, FuelLogsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () =>
              context.read<FuelLogsCubit>().fetch(widget.vehicleId),
          child: switch (state) {
            FuelLogsLoading() || FuelLogsInitial() => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: AppLoadingWidget()),
              ],
            ),
            FuelLogsError(:final message) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 60.h),
                ErrorStateWidget(
                  message: message,
                  onRetry: () =>
                      context.read<FuelLogsCubit>().fetch(widget.vehicleId),
                ),
              ],
            ),
            FuelLogsEmpty() => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [SizedBox(height: 60), EmptyStateWidget()],
            ),
            FuelLogsLoaded(:final items, :final isLoadingMore) =>
              ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                itemCount: items.length + (isLoadingMore ? 1 : 0),
                separatorBuilder: (_, _) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  if (index >= items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return _FuelLogCard(log: items[index]);
                },
              ),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

class _FuelLogCard extends StatelessWidget {
  const _FuelLogCard({required this.log});

  final FuelLogEntity log;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final imageUrl = resolveMediaUrl(log.odometerImage);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.carWashTeal, width: 1),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_gas_station_outlined,
                        color: colorScheme.primary,
                        size: 18.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        l10n.fuelAmountDetailsLabel(
                          log.fuelType ?? '-',
                          log.amount?.toString() ?? '0',
                        ),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    l10n.costWithParamLabel(log.cost?.toString() ?? '-'),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),

                  if (log.kmAtFill != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      l10n.odometerReadingWithParamLabel(
                        log.kmAtFill!.toString(),
                      ),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                  if (log.createdAt != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      log.createdAt!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary(
                          context,
                        ).withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (imageUrl != null) ...[
              SizedBox(width: 10.w),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(
                  imageUrl,
                  width: 64.r,
                  height: 64.r,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 64.r,
                    height: 64.r,
                    color: AppColors.cardBackground(context),
                    child: Icon(
                      Icons.speed_outlined,
                      color: AppColors.textSecondary(
                        context,
                      ).withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
