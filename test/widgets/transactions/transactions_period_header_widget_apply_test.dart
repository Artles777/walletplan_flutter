// ignore_for_file: always_use_package_imports

import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";

import "transactions_period_header_widget_test_helpers.dart";

void main() {
  group("TransactionsPeriodHeaderWidget apply", () {
    testWidgets(
      "selecting a month drills down to day level with full month selected",
      (tester) async {
        final selections = <TransactionsPeriodSelection>[];
        await pumpDefaultHeader(tester, onSelected: selections.add);

        await openPicker(tester);
        await openMonthPicker(tester);
        await tester.tap(monthButton(2));
        await tester.pumpAndSettle();
        await tapOk(tester);

        expect(selections, hasLength(1));
        expect(selections.single.mode, TransactionsPeriodMode.month);
        expect(selections.single.date, DateTime(2026, 2, 1));
        expect(selections.single.endDate, DateTime(2026, 2, 28));
      },
    );

    testWidgets("OK on year level applies whole available year", (
      tester,
    ) async {
      final selections = <TransactionsPeriodSelection>[];
      await pumpDefaultHeader(tester, onSelected: selections.add);

      await openPicker(tester);
      await openYearPicker(tester);
      await tapOk(tester);

      expect(selections, hasLength(1));
      expect(selections.single.mode, TransactionsPeriodMode.year);
      expect(selections.single.date, DateTime(2026, 1, 1));
      expect(selections.single.endDate, DateTime(2026, 3, 20));
    });

    testWidgets("OK on month level applies focused month not whole year", (
      tester,
    ) async {
      final selections = <TransactionsPeriodSelection>[];
      await pumpDefaultHeader(tester, onSelected: selections.add);

      await openPicker(tester);
      await openYearPicker(tester);
      await tester.tap(yearButton(2025));
      await tester.pumpAndSettle();
      await tapOk(tester);

      expect(selections, hasLength(1));
      expect(selections.single.mode, TransactionsPeriodMode.month);
      expect(selections.single.date, DateTime(2025, 3, 1));
      expect(selections.single.endDate, DateTime(2025, 3, 31));
    });

    testWidgets(
      "OK on day-level keeps full available month when range was not changed",
      (tester) async {
        final selections = <TransactionsPeriodSelection>[];
        await pumpDefaultHeader(tester, onSelected: selections.add);

        await openPicker(tester);
        await tapOk(tester);

        expect(selections, hasLength(1));
        expect(selections.single.mode, TransactionsPeriodMode.month);
        expect(selections.single.date, DateTime(2026, 3, 1));
        expect(selections.single.endDate, DateTime(2026, 3, 20));
      },
    );

    testWidgets("manual day range overrides default month selection", (
      tester,
    ) async {
      final selections = <TransactionsPeriodSelection>[];
      await pumpDefaultHeader(tester, onSelected: selections.add);

      await openPicker(tester);
      await tester.tap(dayCell(DateTime(2026, 3, 5)));
      await tester.pumpAndSettle();
      await tester.tap(dayCell(DateTime(2026, 3, 10)));
      await tester.pumpAndSettle();
      await tapOk(tester);

      expect(selections, hasLength(1));
      expect(selections.single.mode, TransactionsPeriodMode.day);
      expect(selections.single.date, DateTime(2026, 3, 5));
      expect(selections.single.endDate, DateTime(2026, 3, 10));
    });

    testWidgets("single tapped day is a valid one-day period", (tester) async {
      final selections = <TransactionsPeriodSelection>[];
      await pumpDefaultHeader(tester, onSelected: selections.add);

      await openPicker(tester);
      await tester.tap(dayCell(DateTime(2026, 3, 7)));
      await tester.pumpAndSettle();
      await tapOk(tester);

      expect(selections, hasLength(1));
      expect(selections.single.mode, TransactionsPeriodMode.day);
      expect(selections.single.date, DateTime(2026, 3, 7));
      expect(selections.single.endDate, isNull);
    });

    testWidgets("callback keeps working for year month and day outputs", (
      tester,
    ) async {
      final selections = <TransactionsPeriodSelection>[];

      await pumpDefaultHeader(tester, onSelected: selections.add);

      await openPicker(tester);
      await openYearPicker(tester);
      await tapOk(tester);

      await pumpHeader(
        tester,
        period: selections.last,
        today: defaultToday,
        onSelected: selections.add,
      );
      await openPicker(tester);
      await openYearPicker(tester);
      await tester.tap(yearButton(2026));
      await tester.pumpAndSettle();
      await tester.tap(monthButton(2));
      await tester.pumpAndSettle();
      await tapOk(tester);

      await pumpHeader(
        tester,
        period: selections.last,
        today: defaultToday,
        onSelected: selections.add,
      );
      await openPicker(tester);
      await tester.tap(dayCell(DateTime(2026, 2, 5)));
      await tester.pumpAndSettle();
      await tester.tap(dayCell(DateTime(2026, 2, 9)));
      await tester.pumpAndSettle();
      await tapOk(tester);

      expect(selections.map((selection) => selection.mode), [
        TransactionsPeriodMode.year,
        TransactionsPeriodMode.month,
        TransactionsPeriodMode.day,
      ]);
    });
  });
}
