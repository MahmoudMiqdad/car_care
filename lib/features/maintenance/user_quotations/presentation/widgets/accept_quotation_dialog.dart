import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

DateTime firstSelectableQuotationDate() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
}

class AcceptQuotationDialogResult {
  const AcceptQuotationDialogResult({
    required this.scheduledDate,
    required this.notes,
  });

  final String scheduledDate;
  final String notes;
}

class AcceptQuotationDialog extends StatefulWidget {
  const AcceptQuotationDialog({super.key});

  @override
  State<AcceptQuotationDialog> createState() => _AcceptQuotationDialogState();
}

class _AcceptQuotationDialogState extends State<AcceptQuotationDialog> {
  late final TextEditingController _notesController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final firstSelectable = firstSelectableQuotationDate();
    final picked = await showDatePicker(
      context: context,
      initialDate: firstSelectable,
      firstDate: firstSelectable,
      lastDate: firstSelectable.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _onConfirm() {
    if (_selectedDate == null) return;
    Navigator.of(context).pop(
      AcceptQuotationDialogResult(
        scheduledDate: _formatDate(_selectedDate!),
        notes: _notesController.text.trim(),
      ),
    );
  }

  void _onCancel() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final radius = BorderRadius.circular(14.r);

    return ClipRRect(
      borderRadius: radius,
      child: Material(
        color: colorScheme.surfaceContainer,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              color: AppColors.carWashTeal,
              child: Text(
                l10n.acceptQuotationTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.selectedDateLabel,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 13.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.carWashTeal,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.carWashTeal,
                            size: 20.r,
                          ),
                          Text(
                            _selectedDate != null
                                ? _formatDate(_selectedDate!)
                                : l10n.chooseDateLabel,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: _selectedDate != null
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 14.h),

                  Text(
                    l10n.notesLabel,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: _notesController,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    maxLines: 3,
                    minLines: 2,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.carWashTeal,
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.carWashTeal,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 48.h,
              color: AppColors.carWashTeal,
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        onTap: _selectedDate != null ? _onConfirm : null,
                        child: Center(
                          child: Text(
                            l10n.confirmLabel,
                            style: TextStyle(
                              color: _selectedDate != null
                                  ? AppColors.white
                                  : AppColors.white.withValues(alpha: 0.4),
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: double.infinity,
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                  Expanded(
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        onTap: _onCancel,
                        child: Center(
                          child: Text(
                            l10n.cancelLabel,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<AcceptQuotationDialogResult?> showAcceptQuotationDialog(
  BuildContext context,
) {
  return showDialog<AcceptQuotationDialogResult>(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      backgroundColor: AppColors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: const AcceptQuotationDialog(),
    ),
  );
}
