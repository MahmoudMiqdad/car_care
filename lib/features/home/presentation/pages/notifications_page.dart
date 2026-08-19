import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/filters/status_filter_tabs.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:car_care/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:car_care/features/notifications/presentation/widgets/notification_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<NotificationsCubit>()..getNotifications(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          title: strings.notifications,
          showBackButton: false,
          actionWidget: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              final showAction = state is NotificationsLoaded &&
                  state.unreadCount > 0 &&
                  !state.isMarkingAll;
              if (!showAction) return const SizedBox.shrink();
              return TextButton(
                onPressed: () =>
                    context.read<NotificationsCubit>().markAllAsRead(),
                child: Text(
                  strings.markAllAsRead,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
        body: ImageBackground(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 12.h),
                const _NotificationsFilterTabs(),
                Expanded(
                  child: BlocConsumer<NotificationsCubit, NotificationsState>(
                    listener: (context, state) {
                      if (state is NotificationsLoaded && state.actionError != null) {
                        AppSnackBar.error(context, state.actionError!);
                        context.read<NotificationsCubit>().clearActionError();
                      }
                    },
                    builder: (context, state) {
                      if (state is NotificationsLoading || state is NotificationsInitial) {
                        return const AppLoadingWidget();
                      }
                      if (state is NotificationsError) {
                        return ErrorStateWidget(
                          message: state.message,
                          onRetry: () =>
                              context.read<NotificationsCubit>().getNotifications(),
                        );
                      }

                      final loaded = state as NotificationsLoaded;
                      return RefreshIndicator(
                        onRefresh: () => context.read<NotificationsCubit>().getNotifications(
                              silent: true,
                              filter: loaded.filter,
                            ),
                        child: loaded.items.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: const [SizedBox(height: 60), EmptyStateWidget()],
                              )
                            : ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                itemCount: loaded.items.length,
                                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                                itemBuilder: (context, index) {
                                  final item = loaded.items[index];
                                  return NotificationCard(
                                    notification: item,
                                    isMarking: loaded.markingIds.contains(item.id),
                                    isDeleting: loaded.deletingIds.contains(item.id),
                                    onTap: () => context
                                        .read<NotificationsCubit>()
                                        .markAsRead(item.id),
                                    onDelete: () => context
                                        .read<NotificationsCubit>()
                                        .deleteNotification(item.id),
                                  );
                                },
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationsFilterTabs extends StatelessWidget {
  const _NotificationsFilterTabs();

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final currentFilter =
            state is NotificationsLoaded ? state.filter : NotificationsFilter.all;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: StatusFilterTabs<NotificationsFilter>(
            items: [
              StatusFilterTabItem(
                value: NotificationsFilter.all,
                label: strings.notificationsAllFilter,
              ),
              StatusFilterTabItem(
                value: NotificationsFilter.unread,
                label: strings.notificationsUnreadFilter,
              ),
            ],
            selected: currentFilter,
            onChanged: (filter) =>
                context.read<NotificationsCubit>().setFilter(filter),
          ),
        );
      },
    );
  }
}
