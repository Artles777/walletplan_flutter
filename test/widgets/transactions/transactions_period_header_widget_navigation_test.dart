// ignore_for_file: always_use_package_imports

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";

import "transactions_period_header_widget_test_helpers.dart";

void main() {
  group("TransactionsPeriodHeaderWidget navigation", () {
    testWidgets("picker always opens in period selection mode", (tester) async {
      await pumpDefaultHeader(tester, onSelected: (_) {});

      await openPicker(tester);

      expect(
        find.byKey(const ValueKey("transactions-period-picker-view-day")),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey("transactions-period-picker-ok")),
        findsOneWidget,
      );
      expect(selectedDay(DateTime(2026, 3, 1)), findsOneWidget);
      expect(selectedDay(DateTime(2026, 3, 20)), findsOneWidget);
    });

    testWidgets("top date navigation row stays outside scrollable body", (
      tester,
    ) async {
      await pumpDefaultHeader(tester, onSelected: (_) {});

      await openPicker(tester);

      expect(scrollBody(), findsOneWidget);
      expect(
        find.ancestor(
          of: find.byKey(
            const ValueKey("transactions-period-picker-header-month"),
          ),
          matching: scrollBody(),
        ),
        findsNothing,
      );
      expect(
        find.ancestor(
          of: find.byKey(
            const ValueKey("transactions-period-picker-header-year"),
          ),
          matching: scrollBody(),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: scrollBody(),
          matching: find.byKey(
            const ValueKey("transactions-period-picker-view-day"),
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      "month header opens month picker and keeps current month focused",
      (tester) async {
        await pumpDefaultHeader(tester, onSelected: (_) {});

        await openPicker(tester);
        await openMonthPicker(tester);

        expect(
          find.byKey(const ValueKey("transactions-period-picker-view-month")),
          findsOneWidget,
        );
        expect(focusedMonth(3), findsOneWidget);
      },
    );

    testWidgets(
      "year header opens year picker and keeps current year focused",
      (tester) async {
        await pumpDefaultHeader(tester, onSelected: (_) {});

        await openPicker(tester);
        await openYearPicker(tester);

        expect(
          find.byKey(const ValueKey("transactions-period-picker-view-year")),
          findsOneWidget,
        );
        expect(focusedYear(2026), findsOneWidget);
      },
    );

    testWidgets("selecting a year opens month level with focused month", (
      tester,
    ) async {
      await pumpDefaultHeader(tester, onSelected: (_) {});

      await openPicker(tester);
      await openYearPicker(tester);
      await tester.tap(yearButton(2025));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey("transactions-period-picker-view-month")),
        findsOneWidget,
      );
      expect(focusedMonth(3), findsOneWidget);
    });

    testWidgets("selecting a month from year flow opens day level", (
      tester,
    ) async {
      final selections = <TransactionsPeriodSelection>[];
      await pumpDefaultHeader(tester, onSelected: selections.add);

      await openPicker(tester);
      await openYearPicker(tester);
      await tester.tap(yearButton(2025));
      await tester.pumpAndSettle();
      await tester.tap(monthButton(2));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey("transactions-period-picker-view-day")),
        findsOneWidget,
      );
      expect(selectedDay(DateTime(2025, 2, 1)), findsOneWidget);
      await tapOk(tester);

      expect(selections, hasLength(1));
    });

    testWidgets(
      "day grid keeps last week visible and renders neighbor month days",
      (tester) async {
        await pumpHeader(
          tester,
          period: TransactionsPeriodSelection(
            date: DateTime(2025, 3, 1),
            mode: TransactionsPeriodMode.month,
          ),
          today: DateTime(2025, 3, 29),
          locale: const Locale("ru"),
          onSelected: (_) {},
        );

        await openPicker(tester);

        expect(dayCell(DateTime(2025, 2, 24)), findsOneWidget);
        expect(dayCell(DateTime(2025, 3, 31)), findsOneWidget);
        expect(dayCell(DateTime(2025, 4, 1)), findsOneWidget);

        final scrollBodyRect = tester.getRect(scrollBody());
        final lastDayRect = tester.getRect(dayCell(DateTime(2025, 3, 31)));

        expect(lastDayRect.bottom, lessThanOrEqualTo(scrollBodyRect.bottom));
      },
    );

    testWidgets("neighbor month days use muted text color", (tester) async {
      await pumpHeader(
        tester,
        period: TransactionsPeriodSelection(
          date: DateTime(2025, 3, 1),
          mode: TransactionsPeriodMode.month,
        ),
        today: DateTime(2025, 3, 29),
        locale: const Locale("ru"),
        onSelected: (_) {},
      );

      await openPicker(tester);

      final previousMonthLabel = tester.widget<Text>(
        dayLabel(DateTime(2025, 2, 24)),
      );
      final nextMonthLabel = tester.widget<Text>(
        dayLabel(DateTime(2025, 4, 1)),
      );
      final colorScheme = Theme.of(tester.element(scrollBody())).colorScheme;

      expect(previousMonthLabel.style?.color, colorScheme.outline);
      expect(nextMonthLabel.style?.color, colorScheme.outline);
    });

    testWidgets("day labels stay fully inside visible cells", (tester) async {
      await pumpHeader(
        tester,
        period: TransactionsPeriodSelection(
          date: DateTime(2025, 3, 1),
          mode: TransactionsPeriodMode.month,
        ),
        today: DateTime(2025, 3, 29),
        locale: const Locale("ru"),
        onSelected: (_) {},
      );

      await openPicker(tester);

      final lastMonthDayCellRect = tester.getRect(
        dayCell(DateTime(2025, 3, 31)),
      );
      final lastMonthDayLabelRect = tester.getRect(
        dayLabel(DateTime(2025, 3, 31)),
      );
      final nextMonthDayCellRect = tester.getRect(
        dayCell(DateTime(2025, 4, 1)),
      );
      final nextMonthDayLabelRect = tester.getRect(
        dayLabel(DateTime(2025, 4, 1)),
      );

      expect(
        lastMonthDayLabelRect.bottom,
        lessThanOrEqualTo(lastMonthDayCellRect.bottom),
      );
      expect(
        nextMonthDayLabelRect.bottom,
        lessThanOrEqualTo(nextMonthDayCellRect.bottom),
      );
    });

    testWidgets("mobile viewport keeps bottom week fully visible", (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await pumpHeader(
        tester,
        period: TransactionsPeriodSelection(
          date: DateTime(2025, 3, 1),
          mode: TransactionsPeriodMode.month,
        ),
        today: DateTime(2025, 3, 29),
        locale: const Locale("ru"),
        onSelected: (_) {},
      );

      await openPicker(tester);

      final scrollBodyRect = tester.getRect(scrollBody());
      final march31LabelRect = tester.getRect(dayLabel(DateTime(2025, 3, 31)));
      final april1LabelRect = tester.getRect(dayLabel(DateTime(2025, 4, 1)));

      expect(march31LabelRect.bottom, lessThanOrEqualTo(scrollBodyRect.bottom));
      expect(april1LabelRect.bottom, lessThanOrEqualTo(scrollBodyRect.bottom));
    });
  });
}
