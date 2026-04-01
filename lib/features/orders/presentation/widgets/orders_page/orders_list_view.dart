import 'package:car_care/features/orders/presentation/models/order_list_item.dart';
import 'package:car_care/features/orders/presentation/widgets/orders_page/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersListView extends StatelessWidget {
  const OrdersListView({
    super.key,
    required this.items,
    required this.onOrderTap,
  });

  final List<OrderListItem> items;
  final ValueChanged<OrderListItem> onOrderTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: 14.h),
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
