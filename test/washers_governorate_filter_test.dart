// اختبارات فلتر المحافظة في قائمة مغاسل السيارات لدى العميل — القائمة
// المنبثقة أصبحت Bottom Sheet مضغوط بارتفاع محدود وScroll بدل PopupMenuButton
// غير المقيّد، مع الحفاظ على الـSentinel وسلوك "كل المحافظات"، وإثبات اختفاء
// شارات BASIC/VIP/PREMIUM من بطاقة القائمة فقط.
import 'package:car_care/core/widgets/filters/generic_dropdown_filter.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/washers_page/washer_listing_card.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/washers_page/washers_governorate_filter.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpWithApp(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

WasherEntity fakeWasher({Map<String, int> servicePrices = const {}}) {
  return WasherEntity(
    id: 1,
    shopName: 'مغسلة الأمل',
    city: 'دمشق',
    address: 'المزة',
    logoUrl: null,
    phone: '0500000000',
    services: servicePrices.keys.toList(),
    servicePrices: servicePrices,
    averageRating: 4.2,
    ratingsCount: 5,
    isAvailable: true,
    isVerified: true,
    openTime: '08:00',
    closeTime: '20:00',
  );
}

void main() {
  group('washersGovernorateFilterOptions — the 14 governorates', () {
    test('contains exactly the required governorates, in order, plus the '
        'null "clear" entry first', () {
      expect(washersGovernorateFilterOptions, [
        null,
        'دمشق',
        'ريف دمشق',
        'حلب',
        'حمص',
        'حماة',
        'اللاذقية',
        'طرطوس',
        'إدلب',
        'درعا',
        'السويداء',
        'القنيطرة',
        'دير الزور',
        'الرقة',
        'الحسكة',
      ]);
    });
  });

  group('WashersGovernorateFilter — trigger', () {
    testWidgets(
      'shows "حسب المحافظة" as the trigger title when nothing is selected',
      (tester) async {
        await pumpWithApp(
          tester,
          WashersGovernorateFilter(
            selectedGovernorate: null,
            onChanged: (_) {},
          ),
        );

        expect(find.text('حسب المحافظة'), findsOneWidget);
      },
    );

    testWidgets('shows the selected governorate as the trigger label', (
      tester,
    ) async {
      await pumpWithApp(
        tester,
        WashersGovernorateFilter(selectedGovernorate: 'حلب', onChanged: (_) {}),
      );

      expect(find.text('حلب'), findsOneWidget);
      expect(find.text('حسب المحافظة'), findsNothing);
    });
  });

  group('WashersGovernorateFilter — the (now bounded, scrollable) list', () {
    // A small physical surface stands in for a small phone screen, so the
    // old bug (the full 15-item list rendering at unconstrained height)
    // would overflow/behave badly here if it still existed.
    Future<void> setSmallScreen(WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets(
      'all 14 governorates plus "كل المحافظات" are present in the list',
      (tester) async {
        await setSmallScreen(tester);
        await pumpWithApp(
          tester,
          WashersGovernorateFilter(
            selectedGovernorate: null,
            onChanged: (_) {},
          ),
        );

        await tester.tap(find.byType(GenericDropdownFilter<String>));
        await tester.pumpAndSettle();

        expect(find.text('كل المحافظات'), findsOneWidget);
        expect(find.text('دمشق'), findsOneWidget);
        // The last governorate isn't necessarily laid out yet (long list,
        // bounded viewport) but must exist once scrolled into view.
        await tester.dragUntilVisible(
          find.text('الحسكة'),
          find.byType(Scrollbar),
          const Offset(0, -60),
        );
        expect(find.text('الحسكة'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the list is capped well under the full screen height on a small '
      'screen, and scrolls (does not overflow) to reach the last item',
      (tester) async {
        await setSmallScreen(tester);
        await pumpWithApp(
          tester,
          WashersGovernorateFilter(
            selectedGovernorate: null,
            onChanged: (_) {},
          ),
        );

        await tester.tap(find.byType(GenericDropdownFilter<String>));
        await tester.pumpAndSettle();

        final screenHeight =
            tester.view.physicalSize.height / tester.view.devicePixelRatio;
        final sheetHeight = tester.getSize(find.byType(Scrollbar)).height;

        expect(sheetHeight, lessThan(screenHeight * 0.6));

        await tester.dragUntilVisible(
          find.text('الحسكة'),
          find.byType(Scrollbar),
          const Offset(0, -60),
        );
        await tester.tap(find.text('الحسكة'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('the currently-selected governorate shows a checkmark', (
      tester,
    ) async {
      await setSmallScreen(tester);
      await pumpWithApp(
        tester,
        WashersGovernorateFilter(selectedGovernorate: 'حلب', onChanged: (_) {}),
      );

      await tester.tap(find.byType(GenericDropdownFilter<String>));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });
  });

  group('WashersGovernorateFilter — selection behavior', () {
    testWidgets('picking a governorate from the list calls onChanged with that '
        'value exactly once', (tester) async {
      final picked = <String?>[];
      await pumpWithApp(
        tester,
        WashersGovernorateFilter(
          selectedGovernorate: null,
          onChanged: picked.add,
        ),
      );

      await tester.tap(find.byType(GenericDropdownFilter<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('حلب'));
      await tester.pumpAndSettle();

      expect(picked, ['حلب']);
    });

    testWidgets(
      'picking "كل المحافظات" clears the filter — onChanged(null) exactly '
      'once',
      (tester) async {
        final picked = <String?>[];
        await pumpWithApp(
          tester,
          WashersGovernorateFilter(
            selectedGovernorate: 'حلب',
            onChanged: picked.add,
          ),
        );

        await tester.tap(find.byType(GenericDropdownFilter<String>));
        await tester.pumpAndSettle();
        // The sheet auto-scrolls to the currently-selected "حلب", which
        // can push "كل المحافظات" (the first item) out of view — jump the
        // scroll position back to the top deterministically before
        // tapping (a drag gesture can leave the item positioned right
        // under the drag-handle area and miss the hit test).
        tester
            .state<ScrollableState>(find.byType(Scrollable))
            .position
            .jumpTo(0);
        await tester.pumpAndSettle();
        await tester.tap(find.text('كل المحافظات'));
        await tester.pumpAndSettle();

        expect(picked, [null]);
      },
    );
  });

  group('GenericDropdownFilter — standalone, not bound to governorates', () {
    testWidgets(
      'works with a plain demo option list unrelated to any feature',
      (tester) async {
        const demoOptions = ['Open', 'Closed', 'Pending'];
        String? picked;

        await pumpWithApp(
          tester,
          GenericDropdownFilter<String>(
            options: demoOptions,
            labelBuilder: (o) => o,
            selectedValue: null,
            triggerLabel: 'Status',
            onChanged: (value) => picked = value,
          ),
        );

        expect(find.text('Status'), findsOneWidget);

        await tester.tap(find.byType(GenericDropdownFilter<String>));
        await tester.pumpAndSettle();

        expect(find.text('Open'), findsOneWidget);
        expect(find.text('Closed'), findsOneWidget);
        expect(find.text('Pending'), findsOneWidget);

        await tester.tap(find.text('Closed'));
        await tester.pumpAndSettle();

        expect(picked, 'Closed');
      },
    );
  });

  group('WasherListingCard — no tier badges in the list card', () {
    testWidgets(
      'BASIC/VIP/PREMIUM never appear on the listing card, even when the '
      'washer has all three service tiers priced',
      (tester) async {
        await pumpWithApp(
          tester,
          WasherListingCard(
            washer: fakeWasher(
              servicePrices: const {'basic': 30, 'vip': 50, 'premium': 80},
            ),
          ),
        );

        expect(find.text('BASIC'), findsNothing);
        expect(find.text('VIP'), findsNothing);
        expect(find.text('PREMIUM'), findsNothing);
        // The rest of the card still renders normally.
        expect(find.text('مغسلة الأمل'), findsOneWidget);
      },
    );
  });
}
