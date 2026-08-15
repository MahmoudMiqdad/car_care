import 'package:car_care/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum CustomerStoreSection { shops, allProducts, cart, orders }

extension CustomerStoreSectionRoute on CustomerStoreSection {
  String get route => switch (this) {
    CustomerStoreSection.shops => Routes.customerShopsList,
    CustomerStoreSection.allProducts => Routes.customerAllProducts,
    CustomerStoreSection.cart => Routes.customerCart,
    CustomerStoreSection.orders => Routes.customerOrders,
  };
}

class CustomerStoreBottomNavBar extends StatelessWidget {
  const CustomerStoreBottomNavBar({super.key, required this.current});

  final CustomerStoreSection current;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: CustomerStoreSection.values.indexOf(current),
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        final target = CustomerStoreSection.values[index];
        if (target == current) return;
        context.go(target.route);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.storefront_outlined),
          label: 'المتاجر',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined),
          label: 'كل المنتجات',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'السلة',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'طلباتي',
        ),
      ],
    );
  }
}
