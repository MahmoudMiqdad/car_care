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
        return (
          bg: const Color(0xFFDFF5E0),
          color: const Color(0xFF2E7D32),
          icon: Icons.check_circle_rounded,
          label: (ctx) => ctx.l10n.statusPaid,
        );
      case 'overdue':
        return (
          bg: const Color(0xFFFFE5E7),
          color: AppColors.red,
          icon: Icons.error_rounded,
          label: (ctx) => ctx.l10n.statusOverdue,
        );
      case 'issued':
        return (
          bg: const Color(0xFFD1F0F7),
          color: const Color(0xFF007A92),
          icon: Icons.receipt_long_rounded,
          label: (ctx) => ctx.l10n.statusIssued,
        );
      case 'draft':
      default:
        return (
          bg: const Color(0xFFF0F0F0),
          color: AppColors.textSecondary(context),
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
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                SizedBox(
                  width: 100.w,
                  child: Container(
                    color: style.bg,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 45.r,
                          height: 45.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: style.color, width: 2.5),
                          ),
                          child: Icon(
                            style.icon,
                            color: style.color,
                            size: 28.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          style.label(context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            color: style.color,
                          ),
                        ),
                      ],
                    ),
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
