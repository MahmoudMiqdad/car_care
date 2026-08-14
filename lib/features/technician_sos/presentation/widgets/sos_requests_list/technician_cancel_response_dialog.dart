import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Asks the technician why they are cancelling their response.
/// Returns the reason, or null when dismissed.
class TechnicianCancelResponseDialog extends StatefulWidget {
  const TechnicianCancelResponseDialog({super.key});

  @override
  State<TechnicianCancelResponseDialog> createState() =>
      _TechnicianCancelResponseDialogState();
}

class _TechnicianCancelResponseDialogState
    extends State<TechnicianCancelResponseDialog> {
  late final TextEditingController _controller;
  String? _error;

  static const int _minLength = 5;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final reason = _controller.text.trim();
    if (reason.isEmpty) {
      setState(() => _error = 'سبب الإلغاء مطلوب');
      return;
    }
    if (reason.length < _minLength) {
      setState(() => _error = 'يرجى كتابة سبب لا يقل عن $_minLength أحرف');
      return;
    }
    Navigator.of(context).pop(reason);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'إلغاء الاستجابة',
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _controller,
          maxLines: 3,
          minLines: 2,
          textDirection: TextDirection.rtl,
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          decoration: InputDecoration(
            labelText: 'سبب إلغاء الاستجابة',
            hintText: 'اكتب سبب إلغاء الاستجابة...',
            errorText: _error,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            contentPadding: EdgeInsets.all(10.w),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _onConfirm,
            child: Text(
              'تأكيد',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'تراجع',
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String?> showTechnicianCancelResponseDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const TechnicianCancelResponseDialog(),
  );
}
