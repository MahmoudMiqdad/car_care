
import 'package:car_care/features/technician/technician_order/domain/entities/available_requests_entity.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/orders_page/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersListView extends StatelessWidget {
  const OrdersListView({
    super.key,
    required this.items,
    required this.onOrderTap,
  });

  final List<AvailableRequestDataEntity> items;
  final ValueChanged<AvailableRequestDataEntity> onOrderTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
      itemCount: items.length,
      separatorBuilder: (_, _) => SizedBox(height: 14.h),
      itemBuilder: (context, index) {
        final item = items[index];

        return OrderCard(
    
          item: item,
          onTap: () => onOrderTap(item),
        );
      },
    );
  }
}
