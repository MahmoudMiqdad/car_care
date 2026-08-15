// نافذة تعديل جزئي لمنتج المالك — السعر والمخزون فقط (الحقول المثبتة في العقد).
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerProductEditResult {
  const OwnerProductEditResult({this.price, this.stockQuantity});

  final double? price;
  final int? stockQuantity;

  bool get isEmpty => price == null && stockQuantity == null;
}

class OwnerProductEditSheet extends StatefulWidget {
  const OwnerProductEditSheet({super.key, required this.product});

  final ProductEntity product;

  static Future<OwnerProductEditResult?> show(
    BuildContext context, {
    required ProductEntity product,
  }) {
    return showModalBottomSheet<OwnerProductEditResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OwnerProductEditSheet(product: product),
    );
  }

  @override
  State<OwnerProductEditSheet> createState() => _OwnerProductEditSheetState();
}

class _OwnerProductEditSheetState extends State<OwnerProductEditSheet> {
  late final TextEditingController _priceCtrl;
  late final TextEditingController _stockCtrl;

  @override
  void initState() {
    super.initState();
    _priceCtrl = TextEditingController(
      text: widget.product.price.toStringAsFixed(0),
    );
    _stockCtrl = TextEditingController(
      text: widget.product.stockQuantity.toString(),
    );
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  void _confirm() {
    final newPrice = double.tryParse(_priceCtrl.text.trim());
    final newStock = int.tryParse(_stockCtrl.text.trim());
    if (newPrice == null || newStock == null) return;

    final result = OwnerProductEditResult(
      price: newPrice == widget.product.price ? null : newPrice,
      stockQuantity: newStock == widget.product.stockQuantity ? null : newStock,
    );
    Navigator.pop(context, result.isEmpty ? null : result);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.85.sh),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          top: false,
          minimum: EdgeInsets.only(bottom: 16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        widget.product.name,
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'السعر',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      TextField(
                        controller: _priceCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        decoration: InputDecoration(
                          suffixText: 'ل.س',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        'الكمية المتوفرة',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      TextField(
                        controller: _stockCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'حفظ التعديل',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
