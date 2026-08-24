import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/filters/status_filter_tabs.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/provider_invoices/domain/entities/provider_invoice_entity.dart';
import 'package:car_care/features/provider_invoices/presentation/cubit/list/provider_invoices_cubit.dart';
import 'package:car_care/features/provider_invoices/presentation/cubit/list/provider_invoices_state.dart';
import 'package:car_care/features/provider_invoices/presentation/widgets/invoice_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

const List<String> _kInvoiceStatusFilterKeys = [
  'draft',
  'issued',
  'paid',
  'overdue',
];

class ProviderInvoicesPage extends StatefulWidget {
  const ProviderInvoicesPage({super.key});

  @override
  State<ProviderInvoicesPage> createState() => _ProviderInvoicesPageState();
}

class _ProviderInvoicesPageState extends State<ProviderInvoicesPage> {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    context.read<ProviderInvoicesCubit>().fetch();
  }

  Future<void> _refresh() {
    return context.read<ProviderInvoicesCubit>().fetch();
  }

  bool _matchesFilter(ProviderInvoiceEntity invoice) {
    if (_selectedStatus == null) return true;
    final effective = invoice.effectiveStatus ?? 'draft';
    return effective == _selectedStatus;
  }

  String _filterLabel(BuildContext context, String key) {
    final l10n = context.l10n;
    return switch (key) {
      'draft' => l10n.statusDraft,
      'issued' => l10n.statusIssued,
      'paid' => l10n.statusPaid,
      'overdue' => l10n.statusOverdue,
      _ => key,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.myInvoices,
        showBackButton: true,
        onBackTapped: () => context.pop(),
      ),
      body: ImageBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: StatusFilterTabs<String?>(
                  items: [
                    StatusFilterTabItem(
                      value: null,
                      label: l10n.bookingStatusAll,
                    ),
                    for (final key in _kInvoiceStatusFilterKeys)
                      StatusFilterTabItem(
                        value: key,
                        label: _filterLabel(context, key),
                      ),
                  ],
                  selected: _selectedStatus,
                  onChanged: (value) => setState(() => _selectedStatus = value),
                ),
              ),
              Expanded(
                child:
                    BlocBuilder<ProviderInvoicesCubit, ProviderInvoicesState>(
                      builder: (context, state) {
                        if (state is ProviderInvoicesLoading) {
                          return const Center(child: AppLoadingWidget());
                        }

                        if (state is ProviderInvoicesError) {
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: 300.h,
                                child: Center(child: Text(state.message)),
                              ),
                            ],
                          );
                        }

                        final invoices = state is ProviderInvoicesLoaded
                            ? state.response.data
                            : const <ProviderInvoiceEntity>[];
                        final filteredInvoices = invoices
                            .where(_matchesFilter)
                            .toList();

                        return RefreshIndicator(
                          onRefresh: _refresh,
                          child: filteredInvoices.isEmpty
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height: 300.h,
                                      child: const EmptyStateWidget(),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 22.w,
                                    vertical: 16.h,
                                  ),
                                  itemCount: filteredInvoices.length,
                                  itemBuilder: (context, index) {
                                    final invoice = filteredInvoices[index];
                                    return InvoiceCard(
                                      invoice: invoice,
                                      onTap: () => context.push(
                                        Routes.providerInvoiceDetails,
                                        extra: invoice.id,
                                      ),
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
    );
  }
}
