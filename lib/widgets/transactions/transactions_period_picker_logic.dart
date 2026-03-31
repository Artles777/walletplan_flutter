import "dart:math" as math;

import "package:flutter/material.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";

part "transactions_period_picker_navigation_logic.dart";
part "transactions_period_picker_display_logic.dart";

/// Contract for the transactions period picker.
///
/// This logic defines the applied period semantics for year/month/day levels,
/// respects `today` / `minDate` / `maxDate` / blocked dates, and must stay
/// cheap enough to run synchronously during dialog open and draft navigation.
/// Do not change these rules without an explicit request to change picker UX.
class TransactionsPeriodPickerConstraints {
  TransactionsPeriodPickerConstraints({
    required DateTime today,
    DateTime? minDate,
    DateTime? maxDate,
    Iterable<DateTime> blockedDates = const [],
  }) : today = startOfDay(today),
       minDate = minDate == null ? null : startOfDay(minDate),
       maxDate = maxDate == null ? null : startOfDay(maxDate),
       blockedDates = normalizeExcludedDates(blockedDates);

  final DateTime today;
  final DateTime? minDate;
  final DateTime? maxDate;
  final List<DateTime> blockedDates;

  DateTime get effectiveMaxDate {
    final upperBound = maxDate;
    if (upperBound == null) {
      return today;
    }

    return upperBound.isBefore(today) ? upperBound : today;
  }

  bool get hasAvailableDates {
    final lowerBound = minDate;
    if (lowerBound == null) {
      return true;
    }

    return !effectiveMaxDate.isBefore(lowerBound);
  }
}

bool isPickerDateSelectable(
  TransactionsPeriodPickerConstraints constraints,
  DateTime date,
) {
  if (!constraints.hasAvailableDates) {
    return false;
  }

  final normalizedDate = startOfDay(date);
  final lowerBound = constraints.minDate;
  if (lowerBound != null && normalizedDate.isBefore(lowerBound)) {
    return false;
  }

  if (normalizedDate.isAfter(constraints.effectiveMaxDate)) {
    return false;
  }

  return !constraints.blockedDates.any(
    (blockedDate) => isSameDay(blockedDate, normalizedDate),
  );
}

List<DateTime> pickerAvailableDatesInRange(
  TransactionsPeriodPickerConstraints constraints, {
  required DateTime start,
  required DateTime end,
}) {
  final normalizedStart = startOfDay(start);
  final normalizedEnd = startOfDay(end);
  if (normalizedEnd.isBefore(normalizedStart)) {
    return const [];
  }

  final dates = <DateTime>[];
  for (
    var date = normalizedStart;
    !date.isAfter(normalizedEnd);
    date = date.add(const Duration(days: 1))
  ) {
    if (isPickerDateSelectable(constraints, date)) {
      dates.add(date);
    }
  }

  return dates;
}

DateTime _clampPickerRangeStart(
  TransactionsPeriodPickerConstraints constraints,
  DateTime start,
) {
  final normalizedStart = startOfDay(start);
  final minDate = constraints.minDate;

  if (minDate == null || !normalizedStart.isBefore(minDate)) {
    return normalizedStart;
  }

  return minDate;
}

DateTime _clampPickerRangeEnd(
  TransactionsPeriodPickerConstraints constraints,
  DateTime end,
) {
  final normalizedEnd = startOfDay(end);
  final maxDate = constraints.effectiveMaxDate;

  if (!normalizedEnd.isAfter(maxDate)) {
    return normalizedEnd;
  }

  return maxDate;
}

List<DateTime> _pickerBlockedDatesInRange(
  TransactionsPeriodPickerConstraints constraints, {
  required DateTime start,
  required DateTime end,
}) {
  return constraints.blockedDates
      .where((blockedDate) {
        return !blockedDate.isBefore(start) && !blockedDate.isAfter(end);
      })
      .toList(growable: false);
}

DateTime? _firstSelectableDateInRange(
  TransactionsPeriodPickerConstraints constraints, {
  required DateTime start,
  required DateTime end,
}) {
  for (
    var date = startOfDay(start);
    !date.isAfter(end);
    date = date.add(const Duration(days: 1))
  ) {
    if (isPickerDateSelectable(constraints, date)) {
      return date;
    }
  }

  return null;
}

DateTime? _lastSelectableDateInRange(
  TransactionsPeriodPickerConstraints constraints, {
  required DateTime start,
  required DateTime end,
}) {
  for (
    var date = startOfDay(end);
    !date.isBefore(start);
    date = date.subtract(const Duration(days: 1))
  ) {
    if (isPickerDateSelectable(constraints, date)) {
      return date;
    }
  }

  return null;
}

TransactionsPeriodSelection? _pickerSelectionFromRange(
  TransactionsPeriodPickerConstraints constraints, {
  required DateTime start,
  required DateTime end,
  required TransactionsPeriodMode mode,
}) {
  if (!constraints.hasAvailableDates) {
    return null;
  }

  final clampedStart = _clampPickerRangeStart(constraints, start);
  final clampedEnd = _clampPickerRangeEnd(constraints, end);
  if (clampedEnd.isBefore(clampedStart)) {
    return null;
  }

  final firstSelectableDate = _firstSelectableDateInRange(
    constraints,
    start: clampedStart,
    end: clampedEnd,
  );
  final lastSelectableDate = _lastSelectableDateInRange(
    constraints,
    start: clampedStart,
    end: clampedEnd,
  );
  if (firstSelectableDate == null || lastSelectableDate == null) {
    return null;
  }

  return TransactionsPeriodSelection(
    date: firstSelectableDate,
    endDate:
        mode == TransactionsPeriodMode.day &&
            isSameDay(firstSelectableDate, lastSelectableDate)
        ? null
        : lastSelectableDate,
    mode: mode,
    excludedDates: _pickerBlockedDatesInRange(
      constraints,
      start: firstSelectableDate,
      end: lastSelectableDate,
    ),
  );
}

TransactionsPeriodSelection? buildFullMonthPeriodSelection(
  TransactionsPeriodPickerConstraints constraints,
  DateTime monthDate,
) {
  final normalizedMonth = DateTime(monthDate.year, monthDate.month);

  return _pickerSelectionFromRange(
    constraints,
    start: normalizedMonth,
    end: endOfMonth(normalizedMonth),
    mode: TransactionsPeriodMode.month,
  );
}

bool monthHasSelectableDate(
  TransactionsPeriodPickerConstraints constraints,
  DateTime monthDate,
) {
  return buildFullMonthPeriodSelection(constraints, monthDate) != null;
}

TransactionsPeriodSelection? buildFullYearPeriodSelection(
  TransactionsPeriodPickerConstraints constraints,
  int year,
) {
  return _pickerSelectionFromRange(
    constraints,
    start: DateTime(year),
    end: endOfYear(DateTime(year)),
    mode: TransactionsPeriodMode.year,
  );
}

bool yearHasSelectableDate(
  TransactionsPeriodPickerConstraints constraints,
  int year,
) {
  return buildFullYearPeriodSelection(constraints, year) != null;
}

TransactionsPeriodSelection? clampPeriodSelectionToConstraints(
  TransactionsPeriodPickerConstraints constraints,
  TransactionsPeriodSelection selection,
) {
  final normalizedSelection = normalizePeriodSelection(selection);

  switch (normalizedSelection.mode) {
    case TransactionsPeriodMode.month:
      if (normalizedSelection.endDate == null) {
        return buildFullMonthPeriodSelection(
          constraints,
          normalizedSelection.date,
        );
      }

      return _pickerSelectionFromRange(
        constraints,
        start: normalizedSelection.date,
        end: normalizedSelection.endDate!,
        mode: normalizedSelection.mode,
      );
    case TransactionsPeriodMode.year:
      if (normalizedSelection.endDate == null) {
        return buildFullYearPeriodSelection(
          constraints,
          normalizedSelection.date.year,
        );
      }

      return _pickerSelectionFromRange(
        constraints,
        start: normalizedSelection.date,
        end: normalizedSelection.endDate!,
        mode: normalizedSelection.mode,
      );
    case TransactionsPeriodMode.day:
      return _pickerSelectionFromRange(
        constraints,
        start: normalizedSelection.date,
        end: periodSelectionEndDate(normalizedSelection),
        mode: normalizedSelection.mode,
      );
  }
}

TransactionsPeriodSelection? fallbackPeriodSelection(
  TransactionsPeriodPickerConstraints constraints,
) {
  if (!constraints.hasAvailableDates) {
    return null;
  }

  return buildFullMonthPeriodSelection(
    constraints,
    constraints.effectiveMaxDate,
  );
}

TransactionsPeriodSelection nextDayRangePeriodSelection({
  required TransactionsPeriodPickerConstraints constraints,
  required TransactionsPeriodSelection? currentSelection,
  required DateTime selectedDate,
}) {
  final normalizedDate = startOfDay(selectedDate);
  if (!isPickerDateSelectable(constraints, normalizedDate)) {
    return currentSelection ??
        TransactionsPeriodSelection(
          date: normalizedDate,
          mode: TransactionsPeriodMode.day,
        );
  }

  if (currentSelection == null ||
      currentSelection.mode != TransactionsPeriodMode.day ||
      currentSelection.endDate != null) {
    return TransactionsPeriodSelection(
      date: normalizedDate,
      mode: TransactionsPeriodMode.day,
    );
  }

  final currentStart = startOfDay(currentSelection.date);
  if (normalizedDate.isBefore(currentStart)) {
    return clampPeriodSelectionToConstraints(
          constraints,
          TransactionsPeriodSelection(
            date: normalizedDate,
            endDate: currentStart,
            mode: TransactionsPeriodMode.day,
          ),
        ) ??
        TransactionsPeriodSelection(
          date: normalizedDate,
          mode: TransactionsPeriodMode.day,
        );
  }

  return clampPeriodSelectionToConstraints(
        constraints,
        TransactionsPeriodSelection(
          date: currentStart,
          endDate: normalizedDate,
          mode: TransactionsPeriodMode.day,
        ),
      ) ??
      TransactionsPeriodSelection(
        date: currentStart,
        mode: TransactionsPeriodMode.day,
      );
}

bool periodSelectionContainsDate(
  TransactionsPeriodSelection selection,
  DateTime date,
) {
  final normalizedSelection = normalizePeriodSelection(selection);
  final normalizedDate = startOfDay(date);
  final selectionEndDate = periodSelectionEndDate(normalizedSelection);
  if (normalizedDate.isBefore(normalizedSelection.date) ||
      normalizedDate.isAfter(selectionEndDate)) {
    return false;
  }

  return !periodExcludesDate(normalizedSelection, normalizedDate);
}

bool periodSelectionContainsMonth(
  TransactionsPeriodPickerConstraints constraints,
  TransactionsPeriodSelection selection,
  DateTime monthDate,
) {
  final normalizedMonth = DateTime(monthDate.year, monthDate.month);
  final monthEnd = endOfMonth(normalizedMonth);
  final selectedDates = pickerAvailableDatesInRange(
    constraints,
    start: normalizedMonth,
    end: monthEnd,
  );

  return selectedDates.any(
    (date) => periodSelectionContainsDate(selection, date),
  );
}
