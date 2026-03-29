import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_logic.dart";

void main() {
  group("transactions period picker logic", () {
    test("always clamps current month to today or maxDate", () {
      final constraints = TransactionsPeriodPickerConstraints(
        today: DateTime(2026, 3, 20),
        maxDate: DateTime(2026, 3, 17),
      );

      final selection = buildFullMonthPeriodSelection(
        constraints,
        DateTime(2026, 3),
      );

      expect(selection, isNotNull);
      expect(selection!.mode, TransactionsPeriodMode.month);
      expect(selection.date, DateTime(2026, 3, 1));
      expect(selection.endDate, DateTime(2026, 3, 17));
    });

    test("days after today or maxDate are disabled and excluded", () {
      final constraints = TransactionsPeriodPickerConstraints(
        today: DateTime(2026, 3, 20),
        maxDate: DateTime(2026, 3, 17),
      );
      final selection = buildFullMonthPeriodSelection(
        constraints,
        DateTime(2026, 3),
      )!;

      expect(
        isPickerDateSelectable(constraints, DateTime(2026, 3, 17)),
        isTrue,
      );
      expect(
        isPickerDateSelectable(constraints, DateTime(2026, 3, 18)),
        isFalse,
      );
      expect(
        periodSelectionContainsDate(selection, DateTime(2026, 3, 17)),
        isTrue,
      );
      expect(
        periodSelectionContainsDate(selection, DateTime(2026, 3, 18)),
        isFalse,
      );
    });

    test("current year auto-selects all available months up to max month", () {
      final constraints = TransactionsPeriodPickerConstraints(
        today: DateTime(2026, 8, 1),
        maxDate: DateTime(2026, 4, 15),
      );

      final months = pickerAvailableMonthsInYear(constraints, 2026);

      expect(months, [1, 2, 3, 4]);
    });

    test(
      "resolveSelectableMonthInYear keeps month focus inside valid year",
      () {
        final constraints = TransactionsPeriodPickerConstraints(
          today: DateTime(2026, 3, 20),
          minDate: DateTime(2025, 3, 10),
          maxDate: DateTime(2026, 2, 10),
        );

        expect(
          resolveSelectableMonthInYear(
            constraints,
            year: 2025,
            preferredMonth: 7,
          ),
          DateTime(2025, 7),
        );
        expect(
          resolveSelectableMonthInYear(
            constraints,
            year: 2026,
            preferredMonth: 7,
          ),
          DateTime(2026, 2),
        );
        expect(
          resolveSelectableMonthInYear(
            constraints,
            year: 2025,
            preferredMonth: 1,
          ),
          DateTime(2025, 3),
        );
      },
    );

    test("month navigation respects min and max month bounds", () {
      final constraints = TransactionsPeriodPickerConstraints(
        today: DateTime(2026, 3, 20),
        minDate: DateTime(2025, 11, 15),
        maxDate: DateTime(2026, 2, 10),
      );

      expect(
        previousSelectableMonth(constraints, DateTime(2025, 12)),
        DateTime(2025, 11),
      );
      expect(previousSelectableMonth(constraints, DateTime(2025, 11)), isNull);
      expect(
        nextSelectableMonth(constraints, DateTime(2026, 1)),
        DateTime(2026, 2),
      );
      expect(nextSelectableMonth(constraints, DateTime(2026, 2)), isNull);
    });

    test("year navigation respects min and max year bounds", () {
      final constraints = TransactionsPeriodPickerConstraints(
        today: DateTime(2026, 8, 1),
        minDate: DateTime(2024, 5, 10),
        maxDate: DateTime(2026, 4, 15),
      );

      expect(previousSelectableYear(constraints, 2025), DateTime(2024, 1));
      expect(previousSelectableYear(constraints, 2024), isNull);
      expect(nextSelectableYear(constraints, 2025), DateTime(2026, 1));
      expect(nextSelectableYear(constraints, 2026), isNull);
    });

    test("previous month navigation skips fully blocked months", () {
      final constraints = TransactionsPeriodPickerConstraints(
        today: DateTime(2026, 6, 30),
        blockedDates: [
          for (int day = 1; day <= 31; day += 1) DateTime(2026, 5, day),
          for (int day = 1; day <= 30; day += 1) DateTime(2026, 4, day),
        ],
      );

      expect(
        previousSelectableMonth(constraints, DateTime(2026, 6)),
        DateTime(2026, 3),
      );
    });

    test("future months without available dates are invalid", () {
      final constraints = TransactionsPeriodPickerConstraints(
        today: DateTime(2026, 3, 20),
      );

      final selection = buildFullMonthPeriodSelection(
        constraints,
        DateTime(2026, 4),
      );

      expect(selection, isNull);
    });

    test("minDate trims full month selection from the left border", () {
      final constraints = TransactionsPeriodPickerConstraints(
        today: DateTime(2026, 3, 31),
        minDate: DateTime(2026, 3, 12),
      );

      final selection = buildFullMonthPeriodSelection(
        constraints,
        DateTime(2026, 3),
      );

      expect(selection, isNotNull);
      expect(selection!.date, DateTime(2026, 3, 12));
      expect(selection.endDate, DateTime(2026, 3, 31));
    });

    test("maxDate trims full year selection from the right border", () {
      final constraints = TransactionsPeriodPickerConstraints(
        today: DateTime(2026, 12, 31),
        maxDate: DateTime(2026, 4, 15),
      );

      final selection = buildFullYearPeriodSelection(constraints, 2026);

      expect(selection, isNotNull);
      expect(selection!.mode, TransactionsPeriodMode.year);
      expect(selection.date, DateTime(2026, 1, 1));
      expect(selection.endDate, DateTime(2026, 4, 15));
    });

    test("blocked dates stay outside applied month selection", () {
      final constraints = TransactionsPeriodPickerConstraints(
        today: DateTime(2026, 3, 31),
        blockedDates: [DateTime(2026, 3, 14)],
      );

      final selection = buildFullMonthPeriodSelection(
        constraints,
        DateTime(2026, 3),
      )!;

      expect(selection.excludedDates, [DateTime(2026, 3, 14)]);
      expect(
        periodSelectionContainsDate(selection, DateTime(2026, 3, 14)),
        isFalse,
      );
      expect(
        periodSelectionContainsDate(selection, DateTime(2026, 3, 15)),
        isTrue,
      );
    });

    test(
      "clampPeriodSelectionToConstraints trims and excludes blocked dates",
      () {
        final constraints = TransactionsPeriodPickerConstraints(
          today: DateTime(2026, 3, 31),
          minDate: DateTime(2026, 3, 10),
          maxDate: DateTime(2026, 3, 20),
          blockedDates: [DateTime(2026, 3, 12)],
        );

        final selection = clampPeriodSelectionToConstraints(
          constraints,
          TransactionsPeriodSelection(
            date: DateTime(2026, 3, 1),
            endDate: DateTime(2026, 3, 30),
            mode: TransactionsPeriodMode.day,
          ),
        );

        expect(selection, isNotNull);
        expect(selection!.date, DateTime(2026, 3, 10));
        expect(selection.endDate, DateTime(2026, 3, 20));
        expect(selection.excludedDates, [DateTime(2026, 3, 12)]);
      },
    );

    test("day range selection swaps bounds and keeps single-day valid", () {
      final constraints = TransactionsPeriodPickerConstraints(
        today: DateTime(2026, 3, 31),
      );

      final singleDay = nextDayRangePeriodSelection(
        constraints: constraints,
        currentSelection: null,
        selectedDate: DateTime(2026, 3, 20),
      );
      final range = nextDayRangePeriodSelection(
        constraints: constraints,
        currentSelection: singleDay,
        selectedDate: DateTime(2026, 3, 10),
      );

      expect(singleDay.date, DateTime(2026, 3, 20));
      expect(singleDay.endDate, isNull);
      expect(range.date, DateTime(2026, 3, 10));
      expect(range.endDate, DateTime(2026, 3, 20));
    });
  });
}
