// ignore_for_file: always_use_package_imports

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";

import "transactions_period_header_widget_test_helpers.dart";

void main() {
  group("TransactionsPeriodHeaderWidget constraints", () {
    testWidgets("future dates and future months are disabled", (tester) async {
      await pumpDefaultHeader(tester, onSelected: (_) {});

      await openPicker(tester);

      expect(
        tester.widget<InkWell>(dayCell(DateTime(2026, 3, 21))).onTap,
        isNull,
      );

      await tester.tap(
        find.byKey(const ValueKey("transactions-period-picker-header-month")),
      );
      await tester.pumpAndSettle();

      expect(tester.widget<FilledButton>(monthButton(4)).onPressed, isNull);
    });

    testWidgets(
      "min max and blocked rules reach callback without early commits",
      (tester) async {
        final selections = <TransactionsPeriodSelection>[];
        await pumpHeader(
          tester,
          period: buildDefaultPeriod(),
          today: DateTime(2026, 3, 31),
          minDate: DateTime(2026, 3, 10),
          maxDate: DateTime(2026, 3, 20),
          blockedDates: [DateTime(2026, 3, 12)],
          onSelected: selections.add,
        );

        await openPicker(tester);
        await tester.tap(
          find.byKey(const ValueKey("transactions-period-picker-header-year")),
        );
        await tester.pumpAndSettle();

        expect(selections, isEmpty);

        await tapOk(tester);

        expect(selections, hasLength(1));
        expect(selections.single.mode, TransactionsPeriodMode.year);
        expect(selections.single.date, DateTime(2026, 3, 10));
        expect(selections.single.endDate, DateTime(2026, 3, 20));
        expect(selections.single.excludedDates, [DateTime(2026, 3, 12)]);
      },
    );
  });
}
