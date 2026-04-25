import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/car_washer/washers/domain/car_wash_listing.dart';
import 'package:car_care/features/car_washer/washers/presentation/data/car_wash_listings_dev_data.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_listing_card.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washers_city_filter_bar.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WashersPage extends StatefulWidget {
  const WashersPage({super.key});

  @override
  State<WashersPage> createState() => _WashersPageState();
}

class _WashersPageState extends State<WashersPage> {
  static const List<CarWashListing> _listings = CarWashListingsDevData.preview;
  String _query = '';

  List<CarWashListing> get _filteredListings {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _listings;
    return _listings.where((item) {
      return item.name.toLowerCase().contains(q) ||
          item.cityName.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _openSearchDialog() async {
    final controller = TextEditingController(text: _query);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.search),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: context.l10n.washersByCity,
            ),
            onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(controller.text),
              child: Text(context.l10n.search),
            ),
          ],
        );
      },
    );

    if (!mounted || result == null) return;
    setState(() => _query = result);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredListings;
    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.washersPageTitle,
        showBackButton: true,
        onBackTapped: () => context.go(Routes.home),
      ),
      body: ImageBackground(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              WashersCityFilterBar(onFilterTap: _openSearchDialog),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          context.l10n.noData,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 18.h),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => SizedBox(height: 18.h),
                        itemBuilder: (context, index) => WasherListingCard(
                          listing: filtered[index],
                          onBook: (w) {},
                          onDetails: (w) {},
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