import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:car_care/features/provider_invoices/domain/entities/provider_invoice_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({super.key, required this.invoice, this.onTap});

  final ProviderInvoiceEntity invoice;
  final VoidCallback? onTap;

  ({Color bg, Color color, IconData icon, String Function(BuildContext) label})
  _statusStyle(BuildContext context) {
    switch (invoice.effectiveStatus) {
      case 'paid':
        final color = AppColors.successColor(context);
        return (
          bg: color.withValues(alpha: 0.12),
          color: color,
          icon: Icons.check_circle_rounded,
          label: (ctx) => ctx.l10n.statusPaid,
        );
      case 'overdue':
        final color = context.colorScheme.error;
        return (
          bg: color.withValues(alpha: 0.12),
          color: color,
          icon: Icons.error_rounded,
          label: (ctx) => ctx.l10n.statusOverdue,
        );
      case 'issued':
        final color = context.colorScheme.primary;
        return (
          bg: color.withValues(alpha: 0.12),
          color: color,
          icon: Icons.receipt_long_rounded,
          label: (ctx) => ctx.l10n.statusIssued,
        );
      case 'draft':
      default:
        final color = AppColors.warningColor(context);
        return (
          bg: color.withValues(alpha: 0.12),
          color: color,
          icon: Icons.edit_note_rounded,
          label: (ctx) => ctx.l10n.statusDraft,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _statusStyle(context);
    final l10n = context.l10n;
    final double localLabelSize = 17.sp;
    final double localValueSize = 16.sp;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            color: context.colorScheme.surfaceContainer,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: style.bg,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(style.icon, size: 14.sp, color: style.color),
                        SizedBox(width: 4.w),
                        Text(
                          style.label(context),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: style.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                AppInfoRow(
                  label: l10n.invoiceNumber,
                  value: invoice.invoiceNumber ?? '-',
                  labelFontSize: localLabelSize,
                  valueFontSize: localValueSize,
                  leading: Icon(
                    Icons.receipt_rounded,
                    size: 20.sp,
                    color: AppColors.primary,
                  ),
                ),
                AppInfoRow(
                  label: l10n.invoicePeriod,
                  value:
                      '${invoice.periodStart ?? '-'} - ${invoice.periodEnd ?? '-'}',
                  labelFontSize: localLabelSize,
                  valueFontSize: localValueSize,
                  leading: Icon(
                    Icons.date_range_rounded,
                    size: 20.sp,
                    color: AppColors.primary,
                  ),
                ),
                AppInfoRow(
                  label: l10n.invoiceTotal,
                  value: '${invoice.totalAmount ?? 0}',
                  labelFontSize: localLabelSize,
                  valueFontSize: localValueSize,
                  leading: Icon(
                    Icons.payments_rounded,
                    size: 20.sp,
                    color: AppColors.primary,
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
