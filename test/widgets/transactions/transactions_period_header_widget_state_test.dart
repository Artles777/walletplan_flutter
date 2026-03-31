// ignore_for_file: always_use_package_imports

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";

import "transactions_period_header_widget_test_helpers.dart";

void main() {
  group("TransactionsPeriodHeaderWidget state", () {
    testWidgets(
      "Cancel discards draft changes and reopen restores applied state",
      (tester) async {
        final selections = <TransactionsPeriodSelection>[];
        await pumpDefaultHeader(tester, onSelected: selections.add);

        await openPicker(tester);
        await tester.tap(
          find.byKey(const ValueKey("transactions-period-picker-header-year")),
        );
        await tester.pumpAndSettle();
        await tester.tap(yearButton(2025));
        await tester.pumpAndSettle();
        await tester.tap(monthButton(2));
        await tester.pumpAndSettle();
        await tester.tap(dayCell(DateTime(2025, 2, 4)));
        await tester.pumpAndSettle();
        await tapCancel(tester);

        expect(selections, isEmpty);

        await openPicker(tester);

        expect(selectedDay(DateTime(2026, 3, 1)), findsOneWidget);
        expect(selectedDay(DateTime(2026, 3, 20)), findsOneWidget);
      },
    );

    testWidgets(
      "reopen restores applied custom range and applied year context",
      (tester) async {
        TransactionsPeriodSelection? customSelection;
        await pumpDefaultHeader(
          tester,
          onSelected: (selection) {
            customSelection = selection;
          },
        );

        await openPicker(tester);
        await tester.tap(dayCell(DateTime(2026, 3, 5)));
        await tester.pumpAndSettle();
        await tester.tap(dayCell(DateTime(2026, 3, 10)));
        await tester.pumpAndSettle();
        await tapOk(tester);

        await pumpHeader(
          tester,
          period: customSelection!,
          today: defaultToday,
          onSelected: (_) {},
        );

        await openPicker(tester);

        expect(selectedDay(DateTime(2026, 3, 5)), findsOneWidget);
        expect(selectedDay(DateTime(2026, 3, 10)), findsOneWidget);
        expect(selectedDay(DateTime(2026, 3, 1)), findsNothing);

        await tapCancel(tester);

        await pumpHeader(
          tester,
          period: TransactionsPeriodSelection(
            date: DateTime(2026, 1, 1),
            endDate: DateTime(2026, 3, 20),
            mode: TransactionsPeriodMode.year,
          ),
          today: defaultToday,
          onSelected: (_) {},
        );

        await openPicker(tester);

        expect(
          find.byKey(const ValueKey("transactions-period-picker-view-year")),
          findsOneWidget,
        );
        expect(focusedYear(2026), findsOneWidget);
      },
    );
  });
}
