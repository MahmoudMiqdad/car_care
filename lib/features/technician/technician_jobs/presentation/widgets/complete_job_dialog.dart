import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Collects the completion notes required by the backend
/// (`completion_notes` is `required_if:status,completed`).
/// Returns the notes, or null when dismissed.
class CompleteJobDialog extends StatefulWidget {
  const CompleteJobDialog({super.key});

  @override
  State<CompleteJobDialog> createState() => _CompleteJobDialogState();
}

class _CompleteJobDialogState extends State<CompleteJobDialog> {
  late final TextEditingController _controller;
  String? _error;

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
    final notes = _controller.text.trim();
    if (notes.isEmpty) {
      setState(() => _error = 'ملاحظات الإنجاز مطلوبة');
      return;
    }
    Navigator.of(context).pop(notes);
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
          'إنهاء المهمة',
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _controller,
          maxLines: 3,
          minLines: 2,
          maxLength: 1000,
          textDirection: TextDirection.rtl,
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          decoration: InputDecoration(
            labelText: 'ملاحظات الإنجاز',
            hintText: 'اكتب ما تم إنجازه...',
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
              'تأكيد الإنهاء',
              style: TextStyle(
                color: AppColors.carWashTeal,
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

Future<String?> showCompleteJobDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const CompleteJobDialog(),
  );
}
