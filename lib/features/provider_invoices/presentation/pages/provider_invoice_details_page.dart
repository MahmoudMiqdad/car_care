import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/provider_invoices/domain/entities/invoice_item_entity.dart';

import 'package:car_care/features/provider_invoices/presentation/cubit/show/show_provider_invoice_cubit.dart';
import 'package:car_care/features/provider_invoices/presentation/cubit/show/show_provider_invoice_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProviderInvoiceDetailsPage extends StatefulWidget {
  const ProviderInvoiceDetailsPage({super.key, required this.invoiceId});

  final String invoiceId;

  @override
  State<ProviderInvoiceDetailsPage> createState() =>
      _ProviderInvoiceDetailsPageState();
}

class _ProviderInvoiceDetailsPageState
    extends State<ProviderInvoiceDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShowProviderInvoiceCubit>().fetchInvoice(widget.invoiceId);
  }

  String _statusLabel(BuildContext context, String? status) {
    final l10n = context.l10n;
    switch (status) {
      case 'paid':
        return l10n.statusPaid;
      case 'overdue':
        return l10n.statusOverdue;
      case 'issued':
        return l10n.statusIssued;
      case 'draft':
      default:
        return l10n.statusDraft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.invoiceDetails,
        showBackButton: true,
        onBackTapped: () => context.pop(),
      ),
      body: ImageBackground(
        child: SafeArea(
          child: BlocBuilder<ShowProviderInvoiceCubit, ShowProviderInvoiceState>(
            builder: (context, state) {
              if (state is ShowProviderInvoiceLoading ||
                  state is ShowProviderInvoiceInitial) {
                return const Center(child: AppLoadingWidget());
              }

              if (state is ShowProviderInvoiceError) {
                return Center(child: Text(state.message));
              }

              final invoice = (state as ShowProviderInvoiceLoaded).invoice;

              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
                children: [
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppInfoRow(
                          label: l10n.invoiceNumber,
                          value: invoice.invoiceNumber ?? '-',
                          leading: Icon(Icons.receipt_rounded,
                              size: 20.sp, color: AppColors.primary),
                        ),
                        AppInfoRow(
                          label: l10n.invoiceStatus,
                          value: _statusLabel(context, invoice.effectiveStatus),
                          leading: Icon(Icons.info_outline_rounded,
                              size: 20.sp, color: AppColors.primary),
                        ),
                        AppInfoRow(
                          label: l10n.invoicePeriod,
                          value:
                              '${invoice.periodStart ?? '-'} - ${invoice.periodEnd ?? '-'}',
                          leading: Icon(Icons.date_range_rounded,
                              size: 20.sp, color: AppColors.primary),
                        ),
                        AppInfoRow(
                          label: l10n.invoiceSubtotal,
                          value: '${invoice.subtotal ?? 0}',
                          leading: Icon(Icons.calculate_outlined,
                              size: 20.sp, color: AppColors.primary),
                        ),
                        AppInfoRow(
                          label: l10n.invoiceCommission,
                          value: '${invoice.commissionTotal ?? 0}',
                          leading: Icon(Icons.percent_rounded,
                              size: 20.sp, color: AppColors.primary),
                        ),
                        AppInfoRow(
                          label: l10n.invoiceSubscription,
                          value: '${invoice.subscriptionTotal ?? 0}',
                          leading: Icon(Icons.subscriptions_outlined,
                              size: 20.sp, color: AppColors.primary),
                        ),
                        AppInfoRow(
                          label: l10n.invoiceTotal,
                          value: '${invoice.totalAmount ?? 0}',
                          leading: Icon(Icons.payments_rounded,
                              size: 20.sp, color: AppColors.primary),
                        ),
                        if (invoice.paidAt != null)
                          AppInfoRow(
                            label: l10n.invoicePaidAt,
                            value: invoice.paidAt.toString(),
                            leading: Icon(Icons.check_circle_outline_rounded,
                                size: 20.sp, color: AppColors.primary),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.invoiceItems,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ...invoice.items.map((item) => _buildItemTile(item)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItemTile(InvoiceItemEntity item) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.description ?? '-',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '${item.amount ?? 0}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}