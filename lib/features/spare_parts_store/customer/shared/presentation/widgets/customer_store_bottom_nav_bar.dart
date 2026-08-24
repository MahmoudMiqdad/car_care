import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
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
    final l10n = context.l10n;

    return BottomNavigationBar(
      backgroundColor: context.colorScheme.surfaceContainer,
      currentIndex: CustomerStoreSection.values.indexOf(current),
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        final target = CustomerStoreSection.values[index];
        if (target == current) return;
        context.go(target.route);
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.storefront_outlined, color: AppColors.primary),
          label: l10n.shopsTitle,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.grid_view_outlined, color: AppColors.primary),
          label: l10n.allProductsPageTitle,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.primary,
          ),
          label: l10n.cartLabel,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.receipt_long_outlined,
            color: AppColors.primary,
          ),
          label: l10n.allRequestsTitle,
        ),
      ],
    );
  }
}
